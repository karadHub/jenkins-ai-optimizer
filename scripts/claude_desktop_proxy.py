#!/usr/bin/env python3
"""
STDIO to HTTP Proxy for Claude Desktop

This script allows Claude Desktop to communicate with the HTTP-based MCP server.
Claude Desktop launches this script and communicates via STDIO (JSON-RPC).
This script forwards requests to the HTTP MCP server.
"""

import sys
import json
import requests
import logging

# Setup logging to stderr (so it doesn't interfere with STDIO JSON-RPC)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    stream=sys.stderr
)
logger = logging.getLogger(__name__)

# HTTP MCP server URL
MCP_SERVER_URL = "http://localhost:3008"


def send_to_mcp_server(message):
    """Forward a message to the HTTP MCP server"""
    try:
        logger.info(f"Forwarding to MCP server: {message.get('method', 'unknown')}")

        # Send POST request to MCP server
        response = requests.post(
            f"{MCP_SERVER_URL}/mcp",
            json=message,
            headers={"Content-Type": "application/json"},
            timeout=30
        )

        if response.status_code == 200:
            return response.json()
        else:
            logger.error(f"HTTP error {response.status_code}: {response.text}")
            return {
                "jsonrpc": "2.0",
                "id": message.get("id"),
                "error": {
                    "code": -32603,
                    "message": f"HTTP error {response.status_code}",
                    "data": response.text
                }
            }
    except Exception as e:
        logger.error(f"Error communicating with MCP server: {e}")
        return {
            "jsonrpc": "2.0",
            "id": message.get("id"),
            "error": {
                "code": -32603,
                "message": "Internal error",
                "data": str(e)
            }
        }


def main():
    """Main loop: read from stdin, forward to HTTP server, write to stdout"""
    logger.info("Claude Desktop Proxy started")
    logger.info(f"Connecting to MCP server at: {MCP_SERVER_URL}")

    try:
        # Read JSON-RPC messages from stdin
        for line in sys.stdin:
            line = line.strip()
            if not line:
                continue

            try:
                # Parse incoming message
                message = json.loads(line)
                logger.info(f"Received from Claude: {message.get('method', message.get('id'))}")

                # Forward to HTTP MCP server
                response = send_to_mcp_server(message)

                # Send response back to Claude Desktop
                response_json = json.dumps(response)
                print(response_json, flush=True)
                logger.info(f"Sent response back to Claude")

            except json.JSONDecodeError as e:
                logger.error(f"Invalid JSON: {e}")
                error_response = {
                    "jsonrpc": "2.0",
                    "error": {
                        "code": -32700,
                        "message": "Parse error",
                        "data": str(e)
                    }
                }
                print(json.dumps(error_response), flush=True)

    except KeyboardInterrupt:
        logger.info("Proxy shutting down...")
    except Exception as e:
        logger.error(f"Fatal error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()

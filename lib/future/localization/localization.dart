class Localization {
  static Map<String, Map<String, String>> get languages => {
        "en": {
          "unsuported_metadata": "Unsuported metadata.",
          "call": "Call",
          "calls": "Call's",
          "read_more": "Read more",
          "casting_failed": "Internal Error: Casting failed.",
          "false": "FALSE",
          "true": "TRUE",
          "tap_to_input_value": "Tap to input value",
          "input_bytes": "Input bytes",
          'setup': "Setup",
          "enter_hex_bytes": "Enter the value in hexadecimal byte format.",
          "bytes": "Bytes",
          "invalid_hex_validator":
              "Invalid hex format. Please enter the value in hexadecimal format",
          "invalid_hex_length":
              "The hexadecimal value must be a ___1__-character string (___2__ bytes).",
          "tap_to_create_object": "Tap to create ___1__ object.",
          "please_enter_a_valid_number": "Please enter a valid number.",
          "invalid_number_validator":
              "Invalid value for type ___1__. Please provide a valid ___1__-bit unsigned integer.",
          "input_string": "Input string",
          "string": "String",
          "enter_valid_address_validator":
              "Please enter a valid ___1__ address.",
          "tools": "Tools",
          "address_to_bytes_desc":
              "Decode your address to bytes, supporting Ethereum, SubstrateApi, Solana, and more.",
          "address_decoder": "Address decoder",
          "address": "Address",
          "convert_address_to_bytes": "Convert the address to bytes.",
          "some_input_not_filled": "Some inputs are not filled.",
          "constants": "Constants",
          "storages": "Storages",
          "retrieving_data_please_wait": "Retrieving data, please wait",
          "get_storage": "Get storage",
          "query_again": "Query again",
          "runtime_apis": "Runtime API's",
          "pallets": "Pallets",
          "call_api": "Call API",
          "call_again": "Call again",
          "extrinsic": "Extrinsic",
          "query_storages_n": "Query Storages ( ___1__ )",
          "query_storages": "Query Storages",
          "inputs_not_needed": "Inputs not needed.",
          "back_to_the_page": "Back to the page",
          "two_n": "___1__ ( ___2__ )",
          "encode_extrinsic": "Encode Extrinsic",
          "encode_call": "Encode Call",
          "encode_again": "Encode again",
          "create_extrinsic_payload": "Create Extrinsic Payload",
          "genesis_hash": "Genesis hash",
          "spec_version": "Spec Version",
          "transaction_version": "Transaction vesrion",
          "quick_access": "Quick Access",
          "block_hash": "Block Hash",
          "finaliz_block_era": "Finaliz Block and Era",
          "finaliz_block": "Finaliz Block",
          "era": "Era",
          "quick_era": "Era: Validated for approximately 150 blocks.",
          "retrieving_constants_please_wait":
              "Retrieving Constants, please wait",
          "retrieving_storages_please_wait": "Retrieving Storages, please wait",
          "create_payload": "Create payload",
          "update_payload": "Update payload",
          "generate_account": "Generate Account",
          "generate_signature": "Generate signature",
          "signing_algorithm": "Signing algorithm",
          "payload": "Payload",
          "private_key": "Private key",
          "invalid_private_key_validator":
              "Invalid private key. The private key must be a valid ___1__ key, either 32 bytes or 64 bytes (including the public key)",
          "sign_payload": "Sign payload",
          "signing_payload_please_wait": "Signing payload, please wait",
          "signature": "Signature",
          "extrinsic_payload": "Extrinsic Payload",
          "serialized_data": "Serialized Data",
          "serialized_data_hash": "Serialized data prepared for signing.",
          "setup_signature": "Setup Signature",
          "setup_extrinsic": "Setup Extrinsic",
          "sing_and_setup_extrinsic": "Sign and setup extrinsic",
          "payload_info": "Payload info",
          "create_extrinsic": "Create Extrinsic",
          "unable_to_find_call_type":
              "Unable to find the Call type in the extrinsic metadata.",
          "creating_payload_please_wait": "Creating payload, please wait.",
          "creating_extrinsic_please_wait": "Creating Extrinsic, please wait.",
          "broadcast_extrinsic": "Broadcast Extrinsic",
          "broadcast_extrinsic_please_wait":
              "Broadcast Extrinsic, please wait.",
          "serialized_call": "Serialized Call",
          "disable": "Disable",
          "network": "Network",
          "back_to_storages": "Back to storages",
          "back_to_apis": "Back to API's",
          "substrate": "Substrate",
          "add_new_chain": "Add new chain",
          "network_name": "Network name",
          "network_name_validator":
              "Network name must contain at least one character.",
          "rpc_url_desc":
              "Please enter a valid URL that starts with http, https, ws, or wss.",
          "rpc_url": "RPC Url",
          "invalid_url": "Please enter a valid URL starting with http or https",
          "network_name_exists":
              "A network with the provided name already exists.",
          "at_least_one_rpc_provider_required":
              "At least one RPC provider is required.",
          "checking_network_connectivity":
              "Checking network connectivity. Please wait",
          "network_imported": "The network has been successfully imported",
          "add_new_service_provider": "Add new service provider",
          "update_chain_provider": "Update chain provider",
          "state_version": "State version",
          "system_version": "System version",
          "metadata_version": "Metadata version",
          "supported_metadata_version": "Supported metadata versions",
          "processing_data_please_wait": "Processing data, please wait",
          "utf8_encoder": "UTF-8 encoder",
          "utf8_encoder_desc":
              "Please enter a string to convert into bytes and hexadecimal format.",
          "unsuported_metadata_version": "Unsuported Metadata version",
          "review_and_sign_payload": "Review and sign payload",
          "review_and_broadcast_extrinsic": "Review and broadcast extrinsic",
          "address_signature_field_not_found_desc":
              "Metadata address and signature fields not found. Please ensure you are using metadata version v15 or v16 to create the extrinsic",
          "create_extrinsics_v14_desc":
              "Creating extrinsics with metadata v14 is unstable and may fail on certain networks. Please use metadata version v15 or v16 for reliable processing.",
          "switching_metadata_please_wait": "Switching metadata, please wait.",
          "request_error": "The request encountered an error",
          "http_error_404":
              "Error 404: Resource Not Found. The requested URL or endpoint could not be located on the server.",
          "http_error_400":
              "Error 400: Bad Request. The server could not understand the request due to invalid syntax or missing parameters.",
          "http_error_401":
              "Error 401: Unauthorized. Access to the requested resource is denied due to missing or incorrect authentication credentials.",
          "http_error_403":
              "Error 403: Forbidden. Access to the requested resource is forbidden.",
          "http_error_405":
              "Error 405: Method Not Allowed. The specified HTTP method is not supported for the requested resource",
          "http_error_408":
              "Error 408: Request Timeout. The server timed out while waiting for the request",
          "http_error_500":
              "Error 500: Internal Server Error. The server encountered an unexpected condition that prevented it from fulfilling the reques",
          "http_error_503":
              "Error 503: Service Unavailable. The server is currently unable to handle the request due to temporary overloading or maintenance of the server",
          "request_cancelled": "The request was cancelled",
          "api_http_timeout_error":
              "Request Timeout: The server did not respond within the specified time frame",
          "api_unknown_error":
              "An unidentified error occurred during the request",
          "copied_to_clipboard": "Copied to cliboard.",
          "copied_to_clipboard_faild": "Copy action unsuccessful.",
          "bytes_tools": "Bytes tools",
          "ss58": "SS58 Format",
          "hrp": "HRP",
          "convert": "Convert",
          "bytes_tools_desc":
              "Bytes Tools: Convert hex bytes to addresses or compute hashes from them",
          "invalid_ssh_58_format": "Invalid SSH58 format.",
          "switch_network": "Switch network",
          "retrieving_metadata_please_wait": "Retrieving metadata, please wait",
          "select_color_from_blow":
              "Select the primary color for the program from the following options:",
          "primary_color": "Primary color",
          "github_address_copied":
              "The repository page url has been copied to clipboard.",
          "account_info": "Account info",
          "account_info_desc": "Account balance, nonce, etc.",
          "enter_signature_desc": "Please provide your signature.",
          "payload_already_signed": "Payload already signed",
          "number_to_decimal": "10^___1__ (___2__)",
          "switching_network_please_wait": "Switching network, please wait.",
          "api_http_client_error":
              "ClientException: An error occurred on the client side during the request."
        }
      };
}

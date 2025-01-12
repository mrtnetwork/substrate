const List<Map<String, dynamic>> defaultChains = [
  {
    "name": "Polkadot",
    "network_type": "",
    "specs": null,
    "rpc_endpoints": [
      {"name": "polkadot.io", "url": "wss://rpc.polkadot.io"},
      {"name": "Stakeworld", "url": "wss://dot-rpc.stakeworld.io:443"},
      {
        "name": "Radium Block",
        "url": "wss://polkadot.public.curie.radiumblock.co:443/ws"
      },
      {
        "name": "OnFinality",
        "url": "wss://polkadot.api.onfinality.io:443/public-ws"
      },
      {"name": "LuckyFriday", "url": "wss://rpc-polkadot.luckyfriday.io:443"},
      {
        "name": "Dwellir Tunisia",
        "url": "wss://polkadot-rpc-tn.dwellir.com:443"
      }
    ]
  },
  {
    "name": "Acala",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "ACA", "ss58_format": 10},
    "rpc_endpoints": [
      {
        "name": "Acala Foundation 0",
        "url": "wss://acala-rpc-0.aca-api.network:443"
      },
      {
        "name": "Acala Foundation 1",
        "url": "wss://acala-rpc-1.aca-api.network:443"
      },
      {
        "name": "Acala Foundation 2",
        "url": "wss://acala-rpc-2.aca-api.network:443/ws"
      },
      {
        "name": "Acala Foundation 3",
        "url": "wss://acala-rpc-3.aca-api.network:443/ws"
      },
      {"name": "Dwellir", "url": "wss://acala-rpc.dwellir.com:443"},
      {
        "name": "OnFinality",
        "url": "wss://acala-polkadot.api.onfinality.io:443/public-ws"
      },
      {"name": "Lucky Friday", "url": "wss://rpc-acala.luckyfriday.io:443"}
    ]
  },
  {
    "name": "Ajuna",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "AJUN", "ss58_format": 1328},
    "rpc_endpoints": [
      {"name": "AjunaNetwork", "url": "wss://rpc-parachain.ajuna.network:443"},
      {
        "name": "RadiumBlock",
        "url": "wss://ajuna.public.curie.radiumblock.co:443/ws"
      },
      {
        "name": "OnFinality",
        "url": "wss://ajuna.api.onfinality.io:443/public-ws"
      }
    ]
  },
  {
    "name": "Aleph Zero",
    "network_type": "solo_mainnet",
    "specs": {"decimals": 12, "token": "AZERO", "ss58_format": 42},
    "rpc_endpoints": [
      {"name": "Aleph Zero Foundation", "url": "wss://ws.azero.dev:443"},
      {"name": "Dwellir", "url": "wss://aleph-zero-rpc.dwellir.com:443"},
      {
        "name": "OnFinality",
        "url": "wss://aleph-zero.api.onfinality.io:443/public-ws"
      }
    ]
  },
  {
    "name": "Aleph Zero Testnet",
    "network_type": "solo_testnet",
    "specs": {"decimals": 12, "token": "TZERO", "ss58_format": 42},
    "rpc_endpoints": [
      {"name": "Aleph Zero Foundation", "url": "wss://ws.test.azero.dev:443"},
      {"name": "Dwellir", "url": "wss://aleph-zero-testnet-rpc.dwellir.com:443"}
    ]
  },
  {
    "name": "Astar",
    "network_type": "mainnet",
    "specs": {"decimals": 18, "token": "ASTR", "ss58_format": 5},
    "rpc_endpoints": [
      {"name": "Astar Team (WSS)", "url": "wss://rpc.astar.network:443"},
      {"name": "BlastAPI (WSS)", "url": "wss://astar.public.blastapi.io:443"},
      {"name": "Dwellir (WSS)", "url": "wss://astar-rpc.dwellir.com:443"},
      {
        "name": "OnFinality (WSS)",
        "url": "wss://astar.api.onfinality.io:443/public-ws"
      },
      {
        "name": "Pinknode (WSS)",
        "url": "wss://public-rpc.pinknode.io:443/astar"
      },
      {"name": "Automata 1RPC (WSS)", "url": "wss://1rpc.io:443/astr"},
      {"name": "Astar Team (HTTPS)", "url": "https://evm.astar.network:443"},
      {
        "name": "BlastAPI (HTTPS)",
        "url": "https://astar.public.blastapi.io:443"
      },
      {"name": "Dwellir (HTTPS)", "url": "https://astar-rpc.dwellir.com:443"},
      {
        "name": "OnFinality (HTTPS)",
        "url": "https://astar.api.onfinality.io:443/public"
      },
      {"name": "Automata 1RPC (HTTPS)", "url": "https://1rpc.io:443/astr"},
      {"name": "Alchemy", "url": "https://www.alchemy.com:443/astar"}
    ]
  },
  {
    "name": "Bajun",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "BAJU", "ss58_format": 1337},
    "rpc_endpoints": [
      {"name": "AjunaNetwork", "url": "wss://rpc-parachain.bajun.network:443"},
      {"name": "Dwellir", "url": "wss://bajun-rpc.dwellir.com:443"},
      {
        "name": "OnFinality",
        "url": "wss://bajun.api.onfinality.io:443/public-ws"
      }
    ]
  },
  {
    "name": "Basilisk",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "BSX", "ss58_format": 10041},
    "rpc_endpoints": [
      {"name": "Dwellir", "url": "wss://basilisk-rpc.dwellir.com:443"},
      {"name": "Basilisk", "url": "wss://rpc.basilisk.cloud:443"}
    ]
  },
  {
    "name": "Bifrost",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "BNC", "ss58_format": 6},
    "rpc_endpoints": [
      {"name": "Bifrost", "url": "wss://hk.p.bifrost-rpc.liebi.com:443/ws"},
      {
        "name": "OnFinality",
        "url": "wss://bifrost-polkadot.api.onfinality.io:443/public-ws"
      }
    ]
  },
  {
    "name": "Bifrost Kusama",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "BNC", "ss58_format": 6},
    "rpc_endpoints": [
      {"name": "Dwellir", "url": "wss://bifrost-rpc.dwellir.com:443"},
      {"name": "Bifrost", "url": "wss://bifrost-rpc.liebi.com:443/ws"},
      {
        "name": "OnFinality",
        "url": "wss://bifrost-parachain.api.onfinality.io:443/public-ws"
      }
    ]
  },
  {
    "name": "Contracts",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://rococo-contracts-rpc.polkadot.io:443"}
    ]
  },
  {
    "name": "HydraDX",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "HDX", "ss58_format": 63},
    "rpc_endpoints": [
      {"name": "Dwellir", "url": "wss://hydradx-rpc.dwellir.com:443"},
      {"name": "HydraDX", "url": "wss://rpc.hydradx.cloud:443"}
    ]
  },
  {
    "name": "Idiyanale Testnet",
    "network_type": "solo_testnet",
    "specs": {"decimals": 12, "token": "IDI", "ss58_format": 42},
    "rpc_endpoints": [
      {
        "name": "Idiyanale Testnet",
        "url": "wss://idiyanale-testnet.anagolay.io:443"
      }
    ]
  },
  {
    "name": "Karura",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "KAR", "ss58_format": 10},
    "rpc_endpoints": [
      {"name": "Dwellir", "url": "wss://karura-rpc.dwellir.com:443"},
      {
        "name": "Acala Foundation 0",
        "url": "wss://karura-rpc-0.aca-api.network:443"
      },
      {
        "name": "Acala Foundation 1",
        "url": "wss://karura-rpc-1.aca-api.network:443"
      },
      {
        "name": "Acala Foundation 2",
        "url": "wss://karura-rpc-2.aca-api.network:443/ws"
      },
      {
        "name": "Acala Foundation 3",
        "url": "wss://karura-rpc-3.aca-api.network:443/ws"
      },
      {"name": "Polkawallet", "url": "wss://karura.polkawallet.io:443"},
      {
        "name": "OnFinality",
        "url": "wss://karura.api.onfinality.io:443/public-ws"
      }
    ]
  },
  {
    "name": "Khala",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "PHA", "ss58_format": 30},
    "rpc_endpoints": [
      {"name": "Dwellir", "url": "wss://khala-rpc.dwellir.com:443"},
      {
        "name": "OnFinality",
        "url": "wss://khala.api.onfinality.io:443/public-ws"
      },
      {"name": "Phala", "url": "wss://khala-api.phala.network:443/ws"},
      {"name": "Pinknode", "url": "wss://public-rpc.pinknode.io:443/khala"}
    ]
  },
  {
    "name": "Kusama",
    "network_type": "canarynet",
    "specs": {"decimals": 12, "token": "KSM", "ss58_format": 2},
    "rpc_endpoints": [
      {"name": "Automata 1RPC", "url": "wss://1rpc.io:443/ksm"},
      {"name": "Dotters Net", "url": "wss://rpc.dotters.network:443/kusama"},
      {"name": "Dwellir", "url": "wss://kusama-rpc.dwellir.com:443"},
      {"name": "Dwellir Tunisia", "url": "wss://kusama-rpc-tn.dwellir.com:443"},
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://rpc.ibp.network:443/kusama"
      },
      {
        "name": "Radium Block",
        "url": "wss://kusama.public.curie.radiumblock.co:443/ws"
      },
      {"name": "Stakeworld", "url": "wss://ksm-rpc.stakeworld.io:443"},
      {"name": "LuckyFriday", "url": "wss://rpc-kusama.luckyfriday.io:443"}
    ]
  },
  {
    "name": "Asset Hub Kusama",
    "network_type": "canarynet",
    "specs": {"decimals": 12, "token": "KSM", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://kusama-asset-hub-rpc.polkadot.io:443"},
      {"name": "Dwellir", "url": "wss://statemine-rpc.dwellir.com:443"},
      {
        "name": "Dwellir Tunisia",
        "url": "wss://statemine-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/statemine"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/statemine"
      },
      {
        "name": "LuckyFriday",
        "url": "wss://rpc-asset-hub-kusama.luckyfriday.io:443"
      },
      {"name": "Stakeworld", "url": "wss://ksm-rpc.stakeworld.io:443/assethub"}
    ]
  },
  {
    "name": "Kusama BridgeHub",
    "network_type": "mainnet",
    "specs": {"decimals": 10, "token": "DOT", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://kusama-bridge-hub-rpc.polkadot.io:443"},
      {"name": "Dwellir", "url": "wss://kusama-bridge-hub-rpc.dwellir.com:443"},
      {
        "name": "Dwellir Tunisia",
        "url": "wss://kusama-bridge-hub-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/bridgehub-kusama"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/bridgehub-kusama"
      },
      {
        "name": "LuckyFriday",
        "url": "wss://rpc-bridge-hub-kusama.luckyfriday.io:443"
      },
      {"name": "Stakeworld", "url": "wss://ksm-rpc.stakeworld.io:443/bridgehub"}
    ]
  },
  {
    "name": "Moonbase Alpha",
    "network_type": "testnet",
    "specs": {"decimals": 18, "token": "DEV", "ss58_format": 1287},
    "rpc_endpoints": [
      {"name": "Blast", "url": "wss://moonbase-alpha.public.blastapi.io:443"},
      {
        "name": "Moonbeam Foundation",
        "url": "wss://wss.api.moonbase.moonbeam.network:443"
      },
      {
        "name": "OnFinality",
        "url": "wss://moonbeam-alpha.api.onfinality.io:443/public-ws"
      },
      {"name": "PinkNode", "url": "wss://public-rpc.pinknode.io:443/alphanet"}
    ]
  },
  {
    "name": "Moonbase Relay",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "UNIT", "ss58_format": 42},
    "rpc_endpoints": [
      {
        "name": "Purestake",
        "url":
            "wss://frag-moonbase-relay-rpc-ws.g.moonbase.moonbeam.network:443"
      }
    ]
  },
  {
    "name": "Moonbeam",
    "network_type": "mainnet",
    "specs": {"decimals": 18, "token": "GLMR", "ss58_format": 1284},
    "rpc_endpoints": [
      {"name": "Automata 1RPC", "url": "wss://1rpc.io/glmr:443"},
      {"name": "Blast", "url": "wss://moonbeam.public.blastapi.io:443"},
      {"name": "Dwellir", "url": "wss://moonbeam-rpc.dwellir.com:443"},
      {
        "name": "Moonbeam Foundation",
        "url": "wss://wss.api.moonbeam.moonbeam.network:443"
      },
      {
        "name": "OnFinality",
        "url": "wss://moonbeam.api.onfinality.io:443/public-ws"
      },
      {"name": "PinkNode", "url": "wss://public-rpc.pinknode.io:443/moonbeam"}
    ]
  },
  {
    "name": "Moonriver",
    "network_type": "mainnet",
    "specs": {"decimals": 18, "token": "MOVR", "ss58_format": 1285},
    "rpc_endpoints": [
      {"name": "Blast", "url": "wss://moonriver.public.blastapi.io:443"},
      {
        "name": "Moonbeam Foundation",
        "url": "wss://wss.api.moonriver.moonbeam.network:443"
      },
      {
        "name": "OnFinality",
        "url": "wss://moonriver.api.onfinality.io:443/public-ws"
      },
      {"name": "PinkNode", "url": "wss://public-rpc.pinknode.io:443/moonriver"}
    ]
  },
  {
    "name": "Paseo",
    "network_type": "testnet",
    "specs": {"decimals": 10, "token": "PAS", "ss58_format": 42},
    "rpc_endpoints": [
      {"name": "Amforc", "url": "wss://paseo.rpc.amforc.com:443"}
    ]
  },
  {
    "name": "Phala",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "PHA", "ss58_format": 30},
    "rpc_endpoints": [
      {
        "name": "OnFinality",
        "url": "wss://phala.api.onfinality.io:443/public-ws"
      },
      {"name": "Phala", "url": "wss://api.phala.network:443/ws"}
    ]
  },
  {
    "name": "Asset Hub Polkadot",
    "network_type": "mainnet",
    "specs": {"decimals": 10, "token": "DOT", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://polkadot-asset-hub-rpc.polkadot.io:443"},
      {"name": "Dwellir", "url": "wss://statemint-rpc.dwellir.com:443"},
      {
        "name": "Dwellir Tunisia",
        "url": "wss://statemint-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/statemint"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/statemint"
      },
      {
        "name": "OnFinality",
        "url": "wss://statemint.api.onfinality.io:443/public-ws"
      },
      {
        "name": "LuckyFriday",
        "url": "wss://rpc-asset-hub-polkadot.luckyfriday.io:443"
      },
      {
        "name": "RadiumBlock",
        "url": "wss://statemint.public.curie.radiumblock.co:443/ws"
      },
      {"name": "Stakeworld", "url": "wss://dot-rpc.stakeworld.io:443/assethub"}
    ]
  },
  {
    "name": "Polkadot BridgeHub",
    "network_type": "mainnet",
    "specs": {"decimals": 10, "token": "DOT", "ss58_format": null},
    "rpc_endpoints": [
      {
        "name": "Parity",
        "url": "wss://polkadot-bridge-hub-rpc.polkadot.io:443"
      },
      {
        "name": "Dwellir",
        "url": "wss://polkadot-bridge-hub-rpc.dwellir.com:443"
      },
      {
        "name": "Dwellir Tunisia",
        "url": "wss://polkadot-bridge-hub-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/bridgehub-polkadot"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/bridgehub-polkadot"
      },
      {
        "name": "LuckyFriday",
        "url": "wss://rpc-bridge-hub-polkadot.luckyfriday.io:443"
      },
      {
        "name": "OnFinality",
        "url": "wss://bridgehub-polkadot.api.onfinality.io:443/public-ws"
      },
      {"name": "Stakeworld", "url": "wss://dot-rpc.stakeworld.io:443/bridgehub"}
    ]
  },
  {
    "name": "Polkadot Collectives",
    "network_type": "mainnet",
    "specs": {"decimals": 10, "token": "DOT", "ss58_format": null},
    "rpc_endpoints": [
      {
        "name": "Parity",
        "url": "wss://polkadot-collectives-rpc.polkadot.io:443"
      },
      {
        "name": "Dwellir",
        "url": "wss://polkadot-collectives-rpc.dwellir.com:443"
      },
      {
        "name": "Dwellir Tunisia",
        "url": "wss://polkadot-collectives-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/collectives-polkadot"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/collectives-polkadot"
      },
      {
        "name": "LuckyFriday",
        "url": "wss://rpc-collectives-polkadot.luckyfriday.io:443"
      },
      {
        "name": "OnFinality",
        "url": "wss://collectives.api.onfinality.io:443/public-ws"
      },
      {
        "name": "RadiumBlock",
        "url": "wss://collectives.public.curie.radiumblock.co:443/ws"
      },
      {
        "name": "Stakeworld",
        "url": "wss://dot-rpc.stakeworld.io:443/collectives"
      }
    ]
  },
  {
    "name": "Rococo",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": 42},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://rococo-rpc.polkadot.io:443"}
    ]
  },
  {
    "name": "Asset Hub Rococo",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://rococo-asset-hub-rpc.polkadot.io:443"},
      {"name": "Dwellir", "url": "wss://rococo-asset-hub-rpc.dwellir.com:443"}
    ]
  },
  {
    "name": "Rococo BridgeHub",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://rococo-bridge-hub-rpc.polkadot.io:443"},
      {"name": "Dwellir", "url": "wss://rococo-bridge-hub-rpc.dwellir.com:443"}
    ]
  },
  {
    "name": "Rococo Coretime",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://rococo-coretime-rpc.polkadot.io:443"}
    ]
  },
  {
    "name": "Shibuya",
    "network_type": "testnet",
    "specs": {"decimals": 18, "token": "SBY", "ss58_format": 5},
    "rpc_endpoints": [
      {
        "name": "Astar Team (WSS)",
        "url": "wss://rpc.shibuya.astar.network:443"
      },
      {"name": "BlastAPI (WSS)", "url": "wss://shiden.public.blastapi.io:443"},
      {"name": "Dwellir (WSS)", "url": "wss://shibuya-rpc.dwellir.com:443"},
      {
        "name": "OnFinality (WSS)",
        "url": "wss://shibuya.api.onfinality.io:443/public-ws"
      },
      {
        "name": "Astar Team (HTTPS, only EVM/Ethereum RPC available)",
        "url": "https://evm.shibuya.astar.network:443"
      },
      {
        "name": "BlastAPI (HTTPS)",
        "url": "https://shibuya.public.blastapi.io:443"
      },
      {"name": "Dwellir (HTTPS)", "url": "https://shibuya-rpc.dwellir.com:443"},
      {
        "name": "OnFinality (HTTPS)",
        "url": "https://shibuya.api.onfinality.io:443/public"
      }
    ]
  },
  {
    "name": "Shiden",
    "network_type": "mainnet",
    "specs": {"decimals": 18, "token": "SDN", "ss58_format": 5},
    "rpc_endpoints": [
      {"name": "Astar Team (WSS)", "url": "wss://rpc.shiden.astar.network:443"},
      {"name": "BlastAPI (WSS)", "url": "wss://shiden.public.blastapi.io:443"},
      {"name": "Dwellir (WSS)", "url": "wss://shiden-rpc.dwellir.com:443"},
      {
        "name": "OnFinality (WSS)",
        "url": "wss://shiden.api.onfinality.io:443/public-ws"
      },
      {
        "name": "Astar Team (HTTPS)",
        "url": "https://evm.shiden.astar.network:443"
      },
      {
        "name": "BlastAPI (HTTPS)",
        "url": "https://shiden.public.blastapi.io:443"
      },
      {"name": "Dwellir (HTTPS)", "url": "https://shiden-rpc.dwellir.com:443"},
      {
        "name": "OnFinality (HTTPS)",
        "url": "https://shiden.api.onfinality.io:443/public"
      }
    ]
  },
  {
    "name": "Tangle Rococo",
    "network_type": "testnet",
    "specs": {"decimals": 18, "token": "tTNT", "ss58_format": 4006},
    "rpc_endpoints": [
      {"name": "Tangle", "url": "wss://tangle-rococo-archive.webb.tools:443"}
    ]
  },
  {
    "name": "Tinkernet",
    "network_type": "mainnet",
    "specs": {"decimals": 12, "token": "TNKR", "ss58_format": 117},
    "rpc_endpoints": [
      {"name": "InvArch Team", "url": "wss://tinker.invarch.network:443"},
      {
        "name": "OnFinality",
        "url": "wss://invarch-tinkernet.api.onfinality.io:443/public-ws"
      }
    ]
  },
  {
    "name": "Tokyo",
    "network_type": "testnet",
    "specs": {"decimals": 18, "token": "TKY", "ss58_format": 42},
    "rpc_endpoints": [
      {"name": "Astar", "url": "wss://tokyo.astar.network:443"}
    ]
  },
  {
    "name": "Watr",
    "network_type": "testnet",
    "specs": {"decimals": 18, "token": "WATRD", "ss58_format": 19},
    "rpc_endpoints": [
      {"name": "Watr", "url": "wss://rpc.watr.org:443"}
    ]
  },
  {
    "name": "Westend",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "WND", "ss58_format": 42},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://westend-rpc.polkadot.io:443"},
      {"name": "Dwellir", "url": "wss://westend-rpc.dwellir.com:443"},
      {
        "name": "Dwellir Tunisia",
        "url": "wss://westend-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://rpc.ibp.network:443/westend"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://rpc.dotters.network:443/westend"
      },
      {"name": "LuckyFriday", "url": "wss://rpc-westend.luckyfriday.io:443"},
      {
        "name": "OnFinality",
        "url": "wss://westend.api.onfinality.io:443/public-ws"
      },
      {
        "name": "RadiumBlock",
        "url": "wss://westend.public.curie.radiumblock.co:443/ws"
      },
      {"name": "Stakeworld", "url": "wss://wnd-rpc.stakeworld.io:443"}
    ]
  },
  {
    "name": "Asset Hub Westend",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "WND", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Dwellir", "url": "wss://westmint-rpc.dwellir.com:443"},
      {
        "name": "Dwellir Tunisia",
        "url": "wss://westmint-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/westmint:443"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/westmint"
      },
      {"name": "Stakeworld", "url": "wss://wnd-rpc.stakeworld.io:443/assethub"}
    ]
  },
  {
    "name": "Westend BridgeHub",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://westend-bridge-hub-rpc.polkadot.io:443"},
      {
        "name": "Dwellir",
        "url": "wss://westend-bridge-hub-rpc.dwellir.com:443"
      },
      {
        "name": "Dwellir Tunisia",
        "url": "wss://westend-bridge-hub-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/bridgehub-westend"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/bridgehub-westend"
      }
    ]
  },
  {
    "name": "Westend Collectives",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "WND", "ss58_format": null},
    "rpc_endpoints": [
      {
        "name": "Parity",
        "url": "wss://collectives-westmint-rpc.polkadot.io:443"
      },
      {
        "name": "Dwellir",
        "url": "wss://westend-collectives-rpc.dwellir.com:443"
      },
      {
        "name": "Dwellir Tunisia",
        "url": "wss://westend-collectives-rpc-tn.dwellir.com:443"
      },
      {
        "name": "IBP Network GeoDNS1",
        "url": "wss://sys.ibp.network:443/collectives-westend"
      },
      {
        "name": "IBP Network GeoDNS2",
        "url": "wss://sys.dotters.network:443/collectives-westend"
      }
    ]
  },
  {
    "name": "Wococo",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "WOOK", "ss58_format": 42},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://wococo-rpc.polkadot.io:443"}
    ]
  },
  {
    "name": "Wococo BridgeHub",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://wococo-bridge-hub-rpc.polkadot.io:443"}
    ]
  },
  {
    "name": "Wococo Wockmint",
    "network_type": "testnet",
    "specs": {"decimals": 12, "token": "ROC", "ss58_format": null},
    "rpc_endpoints": [
      {"name": "Parity", "url": "wss://wococo-wockmint-rpc.polkadot.io:443"}
    ]
  }
];

NODEJS_HEADERS_DIR="$( cd ../../ && cd libnode/ && pwd )"
GYP_DEFINES="OS=ios" CARGO_BUILD_TARGET="aarch64-apple-ios" npm_config_nodedir="$NODEJS_HEADERS_DIR" npm_config_platform="ios" npm_config_format="make-ios" npm_config_node_engine="chakracore" npm_config_arch="arm64" npm --verbose rebuild --build-from-source

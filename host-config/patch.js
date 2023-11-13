// use node fetch to PATCH the host-config endoint
// https://www.balena.io/docs/reference/supervisor/supervisor-api/#patch-v1devicehost-config
const { BALENA_SUPERVISOR_ADDRESS, BALENA_SUPERVISOR_API_KEY } = process.env;
const { PROXY_TYPE, PROXY_HOST, PROXY_PORT, PROXY_USER, PROXY_PASS, NO_PROXY } =
  process.env;
const network = {
  proxy: {},
};

if (PROXY_HOST && PROXY_PORT) {
  network.proxy = {
    type: PROXY_TYPE || "socks5",
    ip: PROXY_HOST,
    port: PROXY_PORT,
    noProxy: [],
  };

  if (PROXY_USER) {
    network.proxy.login = PROXY_USER;
  }

  if (PROXY_PASS) {
    network.proxy.password = PROXY_PASS;
  }

  if (NO_PROXY) {
    network.proxy.noProxy = NO_PROXY.split(",");
  }
}

fetch(
  `${BALENA_SUPERVISOR_ADDRESS}/v1/device/host-config?apikey=${BALENA_SUPERVISOR_API_KEY}`,
  {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ network: network }),
  }
)
  .then((res) => console.log(res.statusText))
  .catch((err) => console.error(err));

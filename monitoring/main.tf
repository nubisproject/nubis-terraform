resource "nrs_monitor" "monitor" {
  name = "${var.account}-${var.service_name}-${var.environment}"

  // The monitor's checking frequency in minutes (one of 1, 5, 10,
  // 15, 30, 60, 360, 720, or 1440).
  frequency = 60

  // The monitoring locations. A list can be found at the endpoint:
  // https://synthetics.newrelic.com/synthetics/api/v1/locations
  locations = ["AWS_US_WEST_1", "LINODE_US_SOUTH_1"]

  status = "ENABLED"

  // The type of monitor (one of SIMPLE, BROWSER, SCRIPT_API,
  // SCRIPT_BROWSER)
  type = "SCRIPT_BROWSER"

  sla_threshold = 1

  // The URI to check. This only applies to SIMPLE and BROWSER
  // monitors.
  uri = "${var.url}"

  // The API or browser script to execute. This only applies to
  // SCRIPT_API or SCRIPT_BROWSER monitors. Docs can be found here:
  // https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/scripting-monitors/write-scripted-browsers
  script = <<EOF
  var site_url = "${var.url}"

  console.log('running test for ' + site_url + ' in ' + $env.LOCATION);

  $browser.get(site_url);
EOF
}

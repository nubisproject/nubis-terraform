resource "nrs_monitor" "monitor" {
  name = "${var.account}-${var.arena}-${var.region}-${var.service_name}-${var.environment}"

  // The monitor's checking frequency in minutes (one of 1, 5, 10,
  // 15, 30, 60, 360, 720, or 1440).
  frequency = "${var.frequency}"

  // The monitoring locations. A list can be found at the endpoint:
  // https://synthetics.newrelic.com/synthetics/api/v1/locations
  locations = "${var.locations}"

  status = "${var.status}"

  // The type of monitor (one of SIMPLE, BROWSER, SCRIPT_API,
  // SCRIPT_BROWSER)
  type = "${var.type}"

  sla_threshold = "${var.sla_treshold}"

  // The URI to check. This only applies to SIMPLE and BROWSER
  // monitors.
  uri = "${var.url}"

  // The API or browser script to execute. This only applies to
  // SCRIPT_API or SCRIPT_BROWSER monitors. Docs can be found here:
  // https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/scripting-monitors/write-scripted-browsers
  script = "${data.template_file.script.rendered}"
}

data "template_file" "script" {
  template = "${file(coalesce(var.script_template, "${path.module}/templates/script.tpl"))}"

  vars {
    URL = "${var.url}"
  }
}

# New Relic Synthetic Module

## Example Usage

```toml
module "monitoring" {
  source       = "github.com/gozer/nubis-terraform//monitoring?ref=issue%2F151%2Fnrs"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  url          = "https://${module.dns.fqdn}/"
}

```

## NEWRELIC_API_KEY

Note: This module expects a NewRelic API key set in the environment
variable **NEWRELIC_API_KEY** and it must be set if you run this module
outside of a Nubis CI instance.

## Arguments

All arguments are optionnal execpt for the url to check

### frequency

Check interval in minutes, allowed values:

- 1
- 5
- 10
- 15
- 30
- 60
- 360
- 720
- 1440

### sla_treshold

Treshold for SLA monitoring in seconds

### status

The enabled status of the checks

- ENABLED
- DISABLED

### type

Type of check. Allowed values:

- SCRIPT_BROWSER (default)
- SIMPLE
- BROWSER
- SCRIPT_API

### locations

The monitoring locations. A list can be found at the endpoint:

<https://synthetics.newrelic.com/synthetics/api/v1/locations>

Default value: ```["AWS_US_WEST_1", "LINODE_US_SOUTH_1"]```

### script_template

Path to a script template, the default is something like:

```javascript
var site_url = '${URL}';

console.log('running test for ' + site_url + ' in ' + $env.LOCATION);

$browser.get(site_url);

```

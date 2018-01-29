var site_url = '${URL}';

// Simplest browser test, just load the home page and call it good

console.log('running test for ' + site_url + ' in ' + $env.LOCATION);

$browser.get(site_url);

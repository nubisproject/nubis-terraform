# The whole user-data, wrapped in a cloudconfig friendly way
output "cloudconfig" {
  value = "${element(concat(data.template_file.user_data_cloudconfig.*.rendered, list("")),0)}"
}

# Just our cloudinit chunk
output "cloudinit" {
  value = "${element(concat(data.template_file.user_data_cloudconfig.*.rendered, list("")),0)}"
}

# The raw nubis-metadata
output "metadata" {
  value = "${element(concat(data.template_file.nubis_metadata.*.rendered, list("")),0)}"
}

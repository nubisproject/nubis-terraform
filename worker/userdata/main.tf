data "template_cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true

  # Setup hello world script to be called by the cloud-config
  part {
    filename     = "nubis-metadata"
    content_type = "text/cloud-config"
    content      = "${data.template_file.user_data_cloudconfig.rendered}"
  }
}

data "template_file" "user_data_cloudconfig" {
  count    = "${var.enabled}"
  template = "${file("${path.module}/templates/userdata_cloudconfig.tpl")}"

  vars {
    PAYLOAD = "${base64encode(data.template_file.nubis_metadata.rendered)}"

    # The nubis-metadata script looks here for it
    LOCATION = "/var/cache/nubis/userdata"
  }
}

data "template_file" "nubis_metadata" {
  count    = "${var.enabled}"
  template = "${file("${path.module}/templates/userdata.tpl")}"

  vars {
    NUBIS_PROJECT       = "${var.service_name}"
    CONSUL_ACL_TOKEN    = "${var.consul_token}"
    NUBIS_PURPOSE       = "${var.purpose}"
    NUBIS_ENVIRONMENT   = "${var.environment}"
    NUBIS_ARENA         = "${var.arena}"
    NUBIS_DOMAIN        = "${var.nubis_domain}"
    NUBIS_ACCOUNT       = "${var.account}"
    NUBIS_STACK         = "${var.service_name}-${var.environment}"
    NUBIS_SUDO_GROUPS   = "${var.nubis_sudo_groups}"
    NUBIS_USER_GROUPS   = "${var.nubis_user_groups}"
    NUBIS_SWAP_SIZE_MEG = "${var.swap_size_meg}"
  }
}

provider "kubernetes" {
  version = "~> 1.10.0"
  host    = google_container_cluster.default.endpoint
  token   = data.google_client_config.current.access_token
  client_certificate = base64decode(google_container_cluster.default.master_auth[0].client_certificate,)
  client_key = base64decode(google_container_cluster.default.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate,)
}

resource "google_compute_address" "default" {
  name   = var.network_name
  region = var.region
}


data "kubectl_filename_list" "manifests" {
    pattern = "./guestbook/*.yaml"
    #pattern = "./wordpress/*.yaml"
}

resource "kubectl_manifest" "test" {
    count = length(data.kubectl_filename_list.manifests.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
}

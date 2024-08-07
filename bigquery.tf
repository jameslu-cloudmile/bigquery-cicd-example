resource "google_bigquery_dataset" "views" {
  dataset_id    = "views"
  friendly_name = "views"
  description   = "This is demo dataset for Terraform"
  location      = "Asia-east1"

  labels = {
    env = "terraform"
    pic = "jon"
  }
}

resource "google_bigquery_table" "iris" {
  dataset_id = google_bigquery_dataset.views.dataset_id
  table_id   = "iris"

  labels = {
    env = "terraform"
    pic = "jon"
  }

  view {
    query          = file("bigquery/views/iris.sql")
    use_legacy_sql = false
  }
}

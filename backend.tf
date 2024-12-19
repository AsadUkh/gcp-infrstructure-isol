terraform {
  backend "remote" {
    organization = "asad-tech"

    workspaces {
      name = "isol-new"
    }
  }
}


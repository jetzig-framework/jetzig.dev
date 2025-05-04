import requests
import json
import os

BASE_URL = "https://api.github.com/repos/jetzig-framework/jetzig/actions/artifacts?per_page=100&name="

def get_artifact_url(build):
    response = requests.get(
        BASE_URL + build,
        headers={
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        }
    )

    data = response.json()
    for artifact in data['artifacts']:
        if artifact['workflow_run']['head_branch'] == 'main':
            return artifact['archive_download_url']

data = []

for build in ("build-windows", "build-macos-x86", "build-macos-aarch64", "build-linux"):
    artifact_url = get_artifact_url(build)

    if artifact_url is None:
        continue

    response = requests.get(
        artifact_url,
        headers={
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28",
            "Authorization": "Bearer " + os.environ['GITHUB_TOKEN']
        }
    )

    path = "/app/public/downloads/" + build + ".zip"
    with open(path, "wb") as file:
        file.write(response.content)

    data_path = "/downloads/" + build + ".zip"
    with open("/app/public/downloads" + build + ".zip", "wb") as file:
        file.write(response.content)

    title = path.replace("/app/public/downloads/", "")
    data.append(dict(title=title, path=data_path))

if data:
    with open('/app/public/downloads/jetzig_downloads.json', 'w') as file:
        file.write(json.dumps(data))

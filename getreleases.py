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

lines = []

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

    path = "/var/www/jetzig/html/downloads/" + build + ".zip"
    with open(path, "wb") as file:
        file.write(response.content)

    relpath = path.replace("/var/www/jetzig/html", "")
    template = "<li>{}: <a href=\"{}\">{}</a></li>\n"
    lines.append(template.format(build.replace("build-", ""), relpath, relpath))

if lines:
    with open('/var/www/jetzig/html/downloads.html') as file:
        content = file.readlines()

    start = content.index("<!-- BUILDS -->\n") + 1
    end = content.index("<!-- /BUILDS -->\n")
    for index in range(start, end):
        content.pop(start)
    for line in lines:
        content.insert(start, line)

    with open('/var/www/jetzig/html/downloads.html', 'w') as file:
        file.writelines(content)

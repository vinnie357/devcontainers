#!/bin/bash
# download latest atc tools
echo "---download latest atc tools---"
toolsList=$(cat -<<EOF
{
  "tools": [
      {
        "name": "f5-declarative-onboarding",
        "version": "1.15.0"
      },
      {
        "name": "f5-appsvcs-extension",
        "version": "3.22.1"
      },
      {
        "name": "f5-telemetry-streaming",
        "version": "1.14.0"
      },
      {
        "name": "f5-cloud-failover-extension",
        "version": "1.5.0"
      },
      {
        "name": "f5-appsvcs-templates",
        "version": "1.4.0"
      }
  ]
}
EOF
)
# accept argument for different tools list
TOOLS=${1:-"$toolsList"}

function getAtc () {
atc=$(echo $toolsList | jq -r .tools[].name)
for tool in $atc
do
    version=$(echo $toolsList | jq -r ".tools[]| select(.name| contains (\"$tool\")).version")
    if [ $version == "latest" ]; then
        path=''
    else
        path='tags/v'
    fi
    echo "downloading $tool, $version"
    #if [[ $tool == "f5-cloud-failover-extension" || $tool == "f5-appsvcs-templates" ]]; then
    if [ $tool == "f5-new-tool" ]; then
        files=$(/usr/bin/curl https://api.github.com/repos/f5devcentral/$tool/releases/$path$version | jq -r '.assets[] | select(.name | contains (".rpm")) | .browser_download_url')
    else
        files=$(/usr/bin/curl https://api.github.com/repos/F5Networks/$tool/releases/$path$version | jq -r '.assets[] | select(.name | contains (".rpm")) | .browser_download_url')
    fi
    for file in $files
    do
    echo "download: $file"
    name=$(basename $file )
    # make download dir
    mkdir -p /var/tmp/f5/atc
    result=$(/usr/bin/curl -Lsk  $file -o /var/tmp/f5/atc/$name)
    done
done
}
getAtc
echo "---downloaded latest atc tools in: '/var/tmp/f5/atc/'---"

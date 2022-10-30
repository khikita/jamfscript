#!/bin/sh

serial=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')

result=$(curl -s --request GET \
     --url $4/api/v1/hardware/byserial/$serial \
     --header 'Authorization: Bearer $5' \
     --header 'accept: application/json')

asset_tag=$(/usr/bin/plutil -extract "rows".0."asset_tag" raw -o - - <<< "${result}")

# Set AssetTAG
sudo jamf recon -assetTag $asset_tag

# Set ComputerName
#/usr/sbin/scutil --set ComputerName $asset_tag
#/usr/sbin/scutil --set LocalHostName $asset_tag
#/usr/sbin/scutil --set HostName $asset_tag

exit 0

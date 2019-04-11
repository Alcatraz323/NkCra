echo "fxckNetKeeper for nk 1.04"
echo "Please enter the Account and password"
account="--"
password="--"
echo "Account => $account"
echo "Password => $password"
echo "read the ifconfig,pls wait"
eth02_mac=$(ifconfig | grep eth0.2 | cut -d " " -f9)
echo "got eth0.2 mac : $eth02_mac"
#macvlan1_mac_raw=$(ifconfig | grep macvlan1)
#macvlan1_mac=${macvlan1_mac_raw:0-20}
#echo "got macvlan1 mac : $macvlan1_mac"
#macvlan2_mac_raw=$(ifconfig | grep macvlan2)
#macvlan2_mac=${macvlan2_mac_raw:0-20}
#echo "got macvlan1 mac : $macvlan2_mac"

echo "=================================="
echo "Pls enter the ip prefix (exp. 100 if ip is 100.x.x.x)"
ip_prefix="100"
ips=$(ifconfig | grep inet\ addr:100 | cut -d ":" -f2 | cut -d " " -f1)
ip1=$(echo $ips | cut -d " " -f1)
echo "ip1 = $ip1"
argument_request_000=$(curl -v -L -S -A "okhttp/3.3.1" -H "Connection: close" -H "Accept-Encoding: gzip" --url www.qq.com)
argument_request_001=$(curl -v -S -A "okhttp/3.3.1" -H "Connection: close" -H "Accept-Encoding: gzip" --url 219.146.3.53:9088/portal/api)
argument_request_002=$(curl -v -S -A "okhttp/3.3.1" -H "Connection: close" -H "Accept-Encoding: gzip" --url 219.146.3.53:9088/portal/v1.0/apps/android/1.0.7)
#ip2=$(echo $ips | cut -d " " -f2)
#echo "ip2 = $ip2"
#ip3=$(echo $ips | cut -d " " -f3)
#echo "ip3 = $ip3"
authorization="219.146.3.53:9088/portal/v1.0/authorize?user_ip=$ip1\&need_refresh_token=false\&scope=portal-rest-api\&response_type=challenge\&user_mac=02-00-00-00-00-00\&require_token=true\&client_id=jportal"
echo $(cat $authorization > a.txt)
argument_request_1=$(curl -v -S -A "okhttp/3.3.1" -H "Connection: close" -H "Accept-Encoding: gzip" --url 219.146.3.53:9088/portal/v1.0/authorize?user_ip=$ip1\&need_refresh_token=false\&scope=portal-rest-api\&response_type=challenge\&user_mac=02-00-00-00-00-00\&require_token=true\&client_id=jportal)  
create_time=$(echo $argument_request_1 | jq -r '.created_at')
echo $create_time
cur_sec_and_ns=`date '+%s-%N'`
cur_ns=${cur_sec_and_ns##*-}
create_time_1=$(($create_time-1))
#create_time_1=$(((cur_sec*1000+cur_ns/1000000)/1000))
echo $create_time_1
nonce_1=$(echo $argument_request_1 | jq -r '.authentication.nonce')
challenge_1=$(echo $argument_request_1 | jq -r '.authentication.challenge')
echo "First request sent"
echo "crt_time = $create_time_1 "
echo "nonce = $nonce_1"  
echo "challenge = $challenge_1"
response=$(echo -n "$challenge_1" | openssl sha1 -hmac "s3cr3t" | cut -d " " -f2)
signature_raw="POST&%2Fportal%2Fv1.0%2Fsessions&Digest nonce=\"$nonce_1\", response=\"$response\", client_id=\"jportal\", signature_method=\"HMAC-SHA1\", timestamp=\"$create_time_1\", version=\"1.0\"&os=android&password=$password&redirect_url=http%3A%2F%2F219.146.3.53%3A9088%3Fsource-ip%3D$ip1%26wlanacname%3D%26nas-ip%3D222.173.128.33%26source-mac%3D$eth02_mac&user_ip=$ip1&user_mac=02-00-00-00-00-00&username=$account&version=1.0.7"
echo $signature_raw
signature=$(echo -n "$signature_raw" | openssl sha1 -hmac "s3cr3t" | cut -d " " -f2)
echo "Calculated hmac-sha1 response => $response"
echo "Calculated hmac-sha1 signature => $signature"
echo "user_ip=$ip1&password=$password&os=android&user_mac=02-00-00-00-00-00&version=1.0.7&redirect_url=http%3A%2F%2F219.146.3.53%3A9088%3Fsource-ip%3D$ip1%26wlanacname%3D%26nas-ip%3D222.173.128.33%26source-mac%3D$eth02_mac&username=$account"
auth1=$(echo " Digest nonce=\"$nonce_1\", response=\"$response\", client_id=\"jportal\", signature=\"$signature\", signature_method=\"HMAC-SHA1\", timestamp=\"$create_time_1\", version=\"1.0\"")
#echo $(curl -v -S --data-urlencode "user_ip=$ip1&context=&user_mac=02-00-00-00-00-00" -A "okhttp/3.3.1" -H "Connection: close" -H "Accept-Encoding: gzip" -H "X-Xinli-Auth: $auth1" --url 219.146.3.53:9088/portal/v1.0/sessions/find)
echo $(curl -v -S --data-urlencode "user_ip=$ip1&password=$password&os=android&user_mac=02-00-00-00-00-00&version=1.0.7&redirect_url=http%3A%2F%2F219.146.3.53%3A9088%3Fsource-ip%3D100.76.1.112%26wlanacname%3D%26nas-ip%3D222.173.128.33%26source-mac%3D$eth02_mac&username=$account" -A "okhttp/3.3.1" -H "Connection: close" -H "Accept:" -H "Accept-Encoding: gzip" -H "X-Xinli-Auth:$auth1" --url 219.146.3.53:9088/portal/v1.0/sessions)
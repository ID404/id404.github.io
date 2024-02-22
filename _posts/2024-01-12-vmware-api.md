---
layout: post
title: 通过API接口操作vmware vcenter虚拟机
keywords: vmware, vcenter, api
description: 通过API接口操作vmware vcenter虚拟机
categories: vmware
---

有台测试的虚拟机经常需要开机或关机操作，每次都通过web界面进行操作的话影响效率。遂通过API进行操作，减少web加载的等待时间。

详细的API接口文档可参考官方链接 :
[vmware API](https://developer.vmware.com/apis/vsphere-automation/v7.0U2-deprecated/vcenter/vm/)

# 首先获取访问API接口的令牌
```bash
curl -s -k -X POST "https://<vcenter-ip>/rest/com/vmware/cis/session" -u <username>:<password> 
```
分别替换\<vcenter-ip>为vcenter的ip; \<username>为vcenter 的用户名 \<password>为vcenter 的密码

注意curl 的方法为 **POST**

正常返回的结果类似这样：

```bash
{"value":"8d152bff9448d85ba377fab5d2712026"}
```
其中8d152bff9448d85ba377fab5d2712026 为令牌内容

# 通过令牌获取需要操作的vm的vm id
```bash
curl -s -k -X GET "https://<vcenter-ip>/rest/vcenter/vm" -H "vmware-api-session-id: <your-session-id>"  | jq
```

分别替换\<vcenter-ip>为vcenter的ip; \<your-session-id>为上一步获取到的令牌

注意curl 的方法为 **GET**

输出的结果为json格式，不太方便看。
```
{"value": [{"memory_size_MiB": 4096,"vm": "vm-5039","name": "vAF_8.0.6","power_state": "POWERED_OFF","cpu_count": 2} ]}
```



可以安装jq工具进行格式化，安装jq后执行(其实就是比上一步多输入 |  jq )：
```
curl -s -k -X GET "https://<vcenter-ip>/rest/vcenter/vm" -H "vmware-api-session-id: <your-session-id>"  | jq
```
输出结果为：

```json
{
  "value": [
    {
      "memory_size_MiB": 4096,
      "vm": "vm-5039",
      "name": "vAF_8.0.6",
      "power_state": "POWERED_OFF",
      "cpu_count": 2
    }
    ]
}
```
其中name为vm的名字，vm为vm id
当然也可以利用jq 通过vm名过滤出vm id,例如要过滤出名字为PA-VM-11的虚拟机的vm id 则执行
```
curl -s -k -X GET "https://<vcenter-ip>/rest/vcenter/vm" -H "vmware-api-session-id: <your-session-id>"  | jq -r '.value[] | select(.name=="PA-VM-11") | .vm
```

# 操作虚拟机

此时令牌、vm id都获取后可进行虚拟机的操作
## 获取当前虚拟机完整信息
```
curl -s -k -X GET "https://<vcenter-ip>/rest/vcenter/vm/<vm-d>/" -H "vmware-api-session-id: <your-session-id>"
```
注意curl 的方法为 **GET**

## 获取当前虚拟机电源状态
只需要在vm id 后面加power字样
```
curl -s -k -X GET "https://<vcenter-ip>/rest/vcenter/vm/<vm-d>/power" -H "vmware-api-session-id: <your-session-id>"
```
注意curl 的方法为 **GET**

## 执行开机操作
```
curl -s -k -X POST "https://<vcenter-ip>/rest/vcenter/vm/<vm-id>/power/start" -H "vmware-api-session-id: <your-session-id>" 
```
注意curl 的方法为 **POST**

## 执行关机操作
```
curl -s -k -X POST "https://<vcenter-ip>/rest/vcenter/vm/<vm-id>/power/stop" -H "vmware-api-session-id: <your-session-id>" 
```
注意curl 的方法为 **POST**

# 成果脚本
将以下代码保存为文件 vm-operator

执行 bash vm-operator start 命令vm id 为vm-800的虚拟机自动开机

执行 bash vm-operator stop 命令vm id 为vm-800的虚拟机自动关机

```bash
#!/bin/bash

#检查 curl 和 jq 命令是否存在
command -v curl > /dev/null 2>&1 || { echo "curl 命令未安装. 请先安装 curl."; exit 1; }
command -v jq > /dev/null 2>&1 || { echo "jq 命令未安装. 请先安装 jq."; exit 1; }

vcenter_ip="10.0.0.3"
vm_id="vm-800"
username="admin"
password="Vmware"

case $# in
   0)
      echo "Usage: $0 {start|stop}"
      exit 1
      ;;
   1)
      response=$(curl -s -k -X POST https://$vcenter_ip/rest/com/vmware/cis/session -u $username:$password )
      session_id=$(echo "$response" | jq -r .value)
      if [ $? -ne 0 ]; then
        echo "登录 VMware vCenter API 失败。请检查 vCenter IP, 用户名和密码。"
        exit 1
      fi

      case $1 in
         start)
            echo "power on vm: win11 test..."
            curl -k -X POST "https://$vcenter_ip/rest/vcenter/vm/$vm_id/power/start" -H "vmware-api-session-id: $session_id"
            echo "Done!"
            ;;
         stop)
            echo "power off vm win 11 test..."
            curl -k -X POST "https://$vcenter_ip/rest/vcenter/vm/$vm_id/power/stop" -H "vmware-api-session-id: $session_id"
            echo "Done!"
            ;;
         *)
            echo "'$1' is not a valid verb."
            echo "Usage: $0 {start|stop}"
            exit 2
            ;;
      esac
      ;;
   *)
      echo "Too many args provided ($#)."
      echo "Usage: $0 {start|stop}"
      exit 3
      ;;
esac

```



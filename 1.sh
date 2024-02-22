#!/bin/bash

# 搜索当前目录及所有子文件夹的txt、html、md文件
for file in $(find . -type f \( -name "*.txt" -o -name "*.html" -o -name "*.md" \))
do
    # 检查文件中是否包含“copyright”文本
    grep -q -i "copyright" "$file"
    if [ $? -eq 0 ]; then
        echo "文件名: $file"
    fi
done


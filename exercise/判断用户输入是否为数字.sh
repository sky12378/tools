echo "请输入数字:"
read INPUT_NUM
if ! [[ "$INPUT_NUM" =~ ^[0-9]+$ ]]
    then
        echo "您输入的不是数字，程序退出"
        exit
fi
echo "您输入的内容是:${INPUT_NUM}"

echo "请输入数字1:"
read INPUT_NUM1
if ! [[ "$INPUT_NUM1" =~ ^[0-9]+$ ]]
    then
        echo "您输入的不是数字，程序退出"
        exit
fi
echo "请输入数字2:"
read INPUT_NUM2
if ! [[ "$INPUT_NUM2" =~ ^[0-9]+$ ]]
    then
        echo "您输入的不是数字，程序退出"
        exit
fi
echo "${INPUT_NUM1}+${INPUT_NUM2}=$((INPUT_NUM1+INPUT_NUM2))"

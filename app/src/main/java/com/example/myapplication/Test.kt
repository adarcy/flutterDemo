package com.example.myapplication

class Test {
//    fun main(args: Array<String?>){
//        val numValue: Int = 128
//        val numValueBox: Int? = numValue
//
///*
//    比较两个数字
// */
//        var result: Boolean
//        result = numValue == numValueBox
//        println("numValue == numValueBox => $result")  // => true,其值是相等的
//
//        result = numValue === numValueBox
///*
//  上面定义的变量是Int类型，大于127其内存地址不同，反之则相同。
//  这是`kotlin`的缓存策略导致的，而缓存的范围是` -128 ~ 127 `。
//  故，下面的打印为false
//*/
//        println("numValue === numValueBox => $result")
//    }

    fun main(args: Array<String>) {
        println(max(args[0].toInt(), args[1].toInt()))

        var x:Int=1;
        when (x) {
            0,1 -> println("x == 0 or x == 1")
            else -> println("otherwise")
        }

        var a: String ?= "abc"
        a = null // compilation error

        var b: String? = "abc"
        println("能为空的字符串是不允许直接调用成员变量或者函数的"
                +if(b!=null) b.length else -1)  //compilation error

        var c: String? = "abcdffffff"
        println(c?.length)  // ok

        var d: String? = "abc"
        val l = d!!.length
        println(""+l)

        val s: Int = if (b != null) b.length else -1
        //等价于
        val f = b?.length ?: -1

    }


    fun max(a: Int, b: Int) :Int{
        if (a > b) return a else return b

    }
}
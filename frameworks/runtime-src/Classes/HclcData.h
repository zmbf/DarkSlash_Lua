#pragma once
#include "cocos2d.h"  
using namespace cocos2d;
using namespace std;

extern "C" {
#include "lua.h"  
#include "lualib.h"  
#include "lauxlib.h"  
};

struct returnTableStruct
{
	string f;
	string s;
};

class HclcData {
public:
	static HclcData* sharedHD();

	//------------  c++ -> lua ------------//  

	/*
	getLuaVarString : 调用lua全局string

	
	varName = 所要取Lua中的变量名
	*/
	const char* getLuaVarString(const char* varName);

	/*
	getLuaVarOneOfTable : 调用lua全局table中的一个元素


	varName = 所要取Lua中的table变量名
	keyName = 所要取Lua中的table中某一个元素的Key
	*/
	const char* getLuaVarOneOfTable(const char* varName, const char* keyName);

	/*
	getLuaVarTable : 调用lua全局table

	
	varName = 所要取的table变量名

	（注：返回的是所有的数据，童鞋们可以自己使用Map等处理）
	*/
	std::vector<returnTableStruct> getLuaVarTable(const char* varName);

	/*
	callLuaFunction : 调用lua函数

	
	functionName = 所要调用Lua中的的函数名
	*/
	const char* callLuaFunction(const char* functionName);
	////带参执行Lua方法有返回值  
	//const char* callLuaFuncParReturn(const char* functionName,std::vector<String>* arraypar,std::vector<String>* arraypartype);  
	////带参执行Lua方法无返回值  
	//const void callLuaFuncPar(const char* functionName,std::vector<String>* arraypar,std::vector<String>* arraypartype);  

	//------------  lua -> c++ ------------//  

	void callCppFunction();

private:
	static int cppFunction(lua_State* ls);

	static bool _isFirst;
	static HclcData* _shared;
	
	~HclcData();
};
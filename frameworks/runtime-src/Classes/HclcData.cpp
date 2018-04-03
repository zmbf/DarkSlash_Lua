#include "HclcData.h"
#include "cocos2d.h"  
#include <map>  
#include <string>   
#include <iostream>   
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
//#include "protobuf_lite/addressbook.pb.h"
#include "cocos2d.h"
bool HclcData::_isFirst;
HclcData* HclcData::_shared;

HclcData* HclcData::sharedHD() {
	if (!_isFirst) {
		_shared = new HclcData();
	}
	return _shared;
}

const char* HclcData::getLuaVarString(const char* varName) {
	lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	lua_settop(ls, 0);
	lua_getglobal(ls, varName);
	int statesCode = lua_isstring(ls, 1);
	if (statesCode != 1) {
		//CCLOG("Open Lua Error: %i", statesCode);
		return NULL;
	}
	const char* str = lua_tostring(ls, 1);
	lua_pop(ls, 1);
	return str;
}

const char* HclcData::getLuaVarOneOfTable(const char* varName, const char* keyName) {

	lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();

	/* int isOpen = luaL_dofile(ls, getFileFullPath());
	if(isOpen!=0){
	CCLOG("Open Lua Error: %i", isOpen);
	return NULL;
	}*/

	lua_getglobal(ls, varName);

	int statesCode = lua_istable(ls, -1);
	if (statesCode != 1) {
		//CCLOG("Open Lua Error: %i", statesCode);
		return NULL;
	}

	lua_pushstring(ls, keyName);
	lua_gettable(ls, -2);
	const char* valueString = lua_tostring(ls, -1);

	lua_pop(ls, -1);

	return valueString;
}

std::vector<returnTableStruct> HclcData::getLuaVarTable(const char* varName) {
	lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	lua_getglobal(ls, varName);
	int it = lua_gettop(ls);
	lua_pushnil(ls);
	string result = "";
	std::vector<returnTableStruct> vmap;
	while (lua_next(ls, it))
	{
		string key = lua_tostring(ls, -2);
		string value = lua_tostring(ls, -1);

		result = result + key + ":" + value + "\t";
		returnTableStruct temp;
		temp.f = key;
		temp.s = value;
		vmap.push_back(temp);
		lua_pop(ls, 1);
	}
	lua_pop(ls, 1);
	return vmap;
}

const char* HclcData::callLuaFunction(const char* functionName) {
	lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();

	

	lua_getglobal(ls, functionName);

	lua_pushstring(ls, "bbjxl");
	lua_pushnumber(ls, 23);
	lua_pushboolean(ls, true);


	/*
	lua_call
	第一个参数:函数的参数个数
	第二个参数:函数返回值个数
	*/
	lua_call(ls, 3, 1);

	const char* iResult = lua_tostring(ls, -1);

	return iResult;
}

//带参执行Lua方法有返回值  
//const char* HclcData::callLuaFuncParReturn(const char* functionName,std::vector<String>* arraypar,std::vector<String>* arraypartype){  
//    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();  
//      
//     
//      
//    lua_getglobal(ls, functionName);  
//  int countnum = arraypar->size();  
//    if(countnum>0)  
//    {  
//        for (int i = 0; i<arraypar->size(); i++) {  
//            String* typestr = (String*)arraypartype[i];  
//            String* strnr = (String*)arraypar[i];  
//            if(typestr->isEqual(String::create("string")))  
//            {  
//                lua_pushstring(ls, strnr->getCString());  
//            }  
//            else if(typestr->isEqual(String::create("int")))  
//            {  
//                lua_pushnumber(ls, strnr->intValue());  
//            }  
//            else if(typestr->isEqual(String::create("bool")))  
//            {  
//                lua_pushboolean(ls, strnr->boolValue());  
//            }  
//        }  
//    }  
//    /*  
//     lua_call  
//     第一个参数:函数的参数个数  
//     第二个参数:函数返回值个数  
//     */  
//    lua_call(ls, countnum, 1);  
//      
//    const char* iResult = lua_tostring(ls, -1);  
//      
//    return iResult;  
//}  

//带参执行Lua方法无返回值  
//const void HclcData::callLuaFuncPar(const char* functionName,CCArray* arraypar,CCArray* arraypartype){  
//    lua_State*  ls = CCLuaEngine::defaultEngine()->getLuaStack()->getLuaState();  
//      
//   
//      
//    lua_getglobal(ls, functionName);  
//    int countnum = arraypar->count();  
//    if(countnum>0)  
//    {  
//        for (int i = 0; i<arraypar->count(); i++) {  
//            CCString* typestr = (CCString*)arraypartype->objectAtIndex(i);  
//            CCString* strnr = (CCString*)arraypar->objectAtIndex(i);  
//            if(typestr->isEqual(CCString::create("string")))  
//            {  
//                lua_pushstring(ls, strnr->getCString());  
//            }  
//            else if(typestr->isEqual(CCString::create("int")))  
//            {  
//                lua_pushnumber(ls, strnr->intValue());  
//            }  
//            else if(typestr->isEqual(CCString::create("bool")))  
//            {  
//                lua_pushboolean(ls, strnr->boolValue());  
//            }  
//        }  
//    }  
//    /*  
//     lua_call  
//     第一个参数:函数的参数个数  
//     第二个参数:函数返回值个数  
//     */  
//    lua_call(ls, countnum, 0);  
//   
//}  


void  HclcData::callCppFunction() {

	lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();

	/*
	Lua调用的C++的函数必须是静态的
	*/
	lua_register(ls, "cppFunction", cppFunction);
}

int HclcData::cppFunction(lua_State* ls) {
	int luaNum = (int)lua_tonumber(ls, 1);
	std::string luaStr = (std::string)lua_tostring(ls, 2);
	//CCLOG("Lua调用cpp函数时传来的两个参数: %i  %s", luaNum, luaStr.c_str());
	//const char* iResults = HclcData::sharedHD()->callLuaFunction("luaLogString");
	/*
	返给Lua的值
	*/
	lua_pushnumber(ls, 321);
	lua_pushstring(ls, "Himi");
	/*
	tutorial::Data data;
	data.set_messagetype(tutorial::Data::login);

	tutorial::Data_Person* person = data.add_persons();
	person->set_name("wowo");
	std::string str = data.SerializeAsString();

	tutorial::Data  data2;
	data2.ParseFromString(str);
	for (int i = 0; i < data2.persons_size(); i++) {
		tutorial::Data::Person  mypersion = data2.persons(i);
		lua_pushstring(ls, mypersion.name().c_str());
		//LabelTTF *label = LabelTTF::create(mypersion.name().c_str(), "Consolas", 40);
		//auto a = mypersion.name();
		//label->setPosition(200, 300);
		//Director::getInstance()->getRunningScene()->addChild(label);
		//addChild(label);
	}
	*/

	/*
	返给Lua值个数
	*/

	return 2;
}



HclcData::~HclcData() {

	CC_SAFE_DELETE(_shared);
	_shared = NULL;
}

// g++ deduplicate.cpp -o deduplicate

#include <iostream>
#include <fstream>
#include <unordered_map>
#include <string>
#include <cstring>

void systemCmd(const char * s);

void ParseArgv(const char * sz, const char * szNext);

bool worked = false;
bool overnow = false;

std::string inputfilename = "";
std::string outputfilename = "";
bool printon = false;

int main(int argc, char * argv[]) {
    systemCmd("chcp 65001");
    if(argc < 2) {
        std::cout << "\n我觉得你应该从cmd或终端中启动该程序并输入下面这句:\ndeduplicate --help\n\nI think you should run this in cmd or terminal and type this:\ndeduplicate --help\n\n";
        systemCmd("pause");
        return 0;
    }

    for(int i = 1; i < argc; i++) {
        if(i == argc - 1) {
            ParseArgv(argv[i], nullptr);
        } else {
            ParseArgv(argv[i], argv[i + 1]);
        }
    }

    if(overnow) {
        return 0;
    }

    if(worked == false) {
        std::cout << "Please use \"deduplicate --help\" to make sure your commands are right." << std::endl;
        return 0;
    }

    std::fstream fin(inputfilename.c_str(), std::ios_base::in);
    if(!fin.is_open()) {
        std::cout << "Can not open \"" << inputfilename.c_str() << "\"" << std::endl;
        return 1;
    }

    if(outputfilename == "") {
        outputfilename = inputfilename + ".out";
    }
    std::fstream fout(outputfilename.c_str(), std::ios_base::out);
    if(!fout.is_open()) {
        std::cout << "Can not open \"" << outputfilename.c_str() << "\"" << std::endl;
        return 1;
    }

    std::string outstr = "";

    int duplicationNum = 0;

    std::unordered_map<std::string, bool> mapDuplicate;
    while(!fin.eof()) {
        std::string strtemp;

        fin >> strtemp;

        if(mapDuplicate.find(strtemp) == mapDuplicate.end()) {
            mapDuplicate[strtemp] = true;
            outstr += strtemp + "\n";
        } else {
            if(printon) {
                std::cout << "Found duplicate word: " << strtemp.c_str() << std::endl;
            }
            duplicationNum++;
        }
    }

    fout << outstr.c_str();

    std::cout << "Over~ Removed " << duplicationNum << " words.\nOutput file: " << outputfilename.c_str() << std::endl;

    return 0;
}

void systemCmd(const char * s) {
#ifdef _WIN32
    system(s);
#endif
}

void ParseArgv(const char * sz, const char * szNext) {
    std::string arg = sz;
    if(arg == "--help") {
        std::cout << "--help              这就是了。So this is it.\n"
            << "--------------------------------------------\n"
            << "[-in <filename>]        输入一个文件来进行去重。Input a file to de-duplicate.\n"
            << "[-out <filename>]       指定输出文件名。Set the output filename.\n"
            << "[-print-on]             允许在运行中输出找到的重复行，主要用于调试。Enable to print the duplications while running, mainly for debug.\n"
            << std::endl;
        overnow = true;
    } else
    if(arg == "-in") {
        if(szNext == nullptr) {
            return;
        }
        inputfilename = szNext;
        
        worked = true;
    } else
    if(arg == "-out") {
        if(szNext == nullptr) {
            return;
        }
        outputfilename = szNext;
        std::cout << "Set output file = " << outputfilename.c_str() << std::endl;

        worked = true;
    } else
    if(arg == "-print-on") {
        printon = true;
        std::cout << "print on" << std::endl;
    }
}

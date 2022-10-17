#pragma once

// 我不确定以后会不会可能需要记录一些别的东西，或者什么别的举报系统相关的事项
// 所以就单独孤立出来一个头文件了

#include "logger.h"

#define LOG_REPORT(format, ...) LOG_IMPL(ReportRecorder::Instance().m_logger, util::LogLevel::REPORT, format, ##__VA_ARGS__);

namespace wheat {
	class ReportRecorder {
	public:
		ReportRecorder() {
			m_logger.SetLogToFile("report");
		}

		static ReportRecorder & Instance() {
			static ReportRecorder instance;
			return instance;
		}

		util::SimpleLogger m_logger;
	};
}


#include "asio.hpp"
#include "sleeper.h"
#include "room.h"
#include "logger.h"

constexpr uint16_t PORT = 11451;

asio::awaitable<void> Listener(asio::ip::tcp::acceptor acceptor)
{
    wheat::Room room;
    for (;;)
    {
        std::make_shared<wheat::Sleeper>(
            room,
            co_await acceptor.async_accept(asio::use_awaitable)
            )->Start();
    }
}

int main()
{
    util::g_logger.SetLogMode(LOG_CONSOLE | LOG_FILE);
    util::g_logger.SetLogToFile("sleep_server");

    try
    {
        asio::io_context io_context(1);
        asio::co_spawn(
            io_context,
            Listener(asio::ip::tcp::acceptor(io_context, { asio::ip::tcp::v4(), PORT })),
            asio::detached);

        asio::signal_set signals(io_context, SIGINT, SIGTERM);
        signals.async_wait([&](auto, auto) { io_context.stop(); });

        io_context.run();
    }
    catch (std::exception& e)
    {
        LOG_FATAL("%s", e.what());
    }

}
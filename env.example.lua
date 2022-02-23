return {
    APP_ENV = "production", -- dev/production
    APP_DOMAIN = 'api.lua-china.com',

    mysql_config = {
        db_name = "lua_china",
        write = {host="172.27.0.6", port=3306, user="root", password=""}, -- mysql write database
        read = {host="172.27.0.6", port=3306, user="root", password=""}, -- mysql read database
    },

    redis_host = "172.16.252.232", -- redis host
    redis_port = 6379, -- redis port

    github = {
        CLIENT_ID = "6162c14c3b7a50abf8ce",
        CLIENT_SECRET = "",
        REDIRECT_URL = "https://api.lua-china.com/oauth/github",
    }
}

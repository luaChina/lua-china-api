local wechat_service = require('services.wechat_service')
local github_service = require("services.github_service")
local validator = require("lib.validator")
local request = require("lib.request")
local response = require("lib.response")
local config = require("config.app")
local user_service = require("services.user_service")
local storage_service = require("services.storage_service")
local cjson = require("cjson")
local User = require('models.user')

local _M = {}

function _M:wechat_login()
    local args = request:all()
    local ok,msg = validator:check(args, {
        'code',
        'state'
        })
    if not ok then
        return response:json(1, msg)
    end
    
    local ok, msg, user = wechat_service:web_login(args.code, args.state)
    if not ok then
        return response:json(ok, msg)
    end
    user_service:authorize(user)
    -- ngx.redirect(config.app_url)
end

function _M:get_userinfo()
    local res, msg = wechat_service:get_userinfo()
end

function _M:github_login()
    local args = request:all()
    local ok,msg = validator:check(args, {
        'code',
        })
    if not ok then
        return response:json(1, msg)
    end
    local access_token, err = github_service:get_access_token(args)
    if err ~= nil then
        ngx.log(ngx.ERR, err)
        return response:json(0x050001)
    end
    local data, err = github_service:get_userinfo(access_token)
    if err ~= nil then
        ngx.log(ngx.ERR, err)
        return response:json(0x050004)
    end
    local email = data.email
    -- 主动获取邮箱信息
    if email == ngx.null then
        email, err = github_service:get_emails(access_token)
        if err ~= nil then
            ngx.log(ngx.ERR, err)
            email = ""
            -- email 可以为空，不影响主流程
        end
    end
    local user = User:where('oauth_id', '=', data.id):first()
    local name = data.login
    if data.name ~= ngx.null then
        name = data.name
    end
    if not user then
        -- 保存头像
        local avatar, err = storage_service:upload_by_url(data.avatar_url)
        if err ~= nil then
            ngx.log(ngx.ERR, err)
        end
        local user_obj = {
            name = name,
            password = '',
            phone = data.id,
            email = email,
            city = data.location,
            oauth_id = data.id,
            oauth_from = 'github',
            avatar = avatar
        }
        local ok = User:create(user_obj)
        if not ok then
            return response:json(0x000005)
        end
        user = User:where('oauth_id', '=', data.id):first()
        if not user then
            return response:json(0x000005)
        end
    else
        -- 每次都更新用户邮箱，之后增加个人中心的设置之后取消掉这里
        local res = User:where('oauth_id', '=', data.id):update({email = email})
        if res ~= 1 then
            ngx.log(ngx.ERR, 'update user email error ' .. res)
        end
    end
    local ok, err = user_service:authorize(user)
    if err ~= nil then
        ngx.log(ngx.ERR, err)
        return response:json(0x050002)
    end
    if not ok then
        ngx.log(ngx.ERR, err)
        return response:json(0x050002)
    end
    ngx.redirect(config.web_url)
end

return _M
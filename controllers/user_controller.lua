local request = require('lib.request')
local response = require('lib.response')
local validator = require('lib.validator')
local auth = require("lib.auth_service_provider")
local User = require("models.user")
local Post = require("models.post")
local Comment = require("models.comment")
local config = require("config.app")
local user_service = require('services.user_service')
local helpers = require("lib.helpers")
local table_remove = helpers.table_remove

local _M = {}

function _M:count()
    return response:json(0, 'show', User:count())
end

function _M:top()
    return response:json(0, 'top', table_remove(User:where('source', '=', 0):orderby('created_at', 'desc'):get(5), {'password', 'phone'}))
end

function _M:show(id)
    local user = User:find(id)
    if not user then
        return response:json(0x010009)
    end
    return response:json(0, 'ok', table_remove(user, {'password'}))
end

function _M:userinfo()
    local user = auth:user()
    user = User:find(user.id)
    return response:json(0, 'ok', table_remove(user, {'password'}))
end

function _M:posts(user_id)
    local user = auth:user()
    local is_owner = false
    if user and tostring(user.id) == tostring(user_id) then
        is_owner = true
    end

    local query = Post:where('deleted_at', 'is', 'null'):where('user_id', '=', user_id)
    
    if not is_owner then
        query = query:where('status', '=', 1)
    end
    
    local posts = query:get()
    return response:json(0, 'ok', posts)
end

function _M:comments(user_id)
    local comments = Comment:where('user_id', '=', user_id):with('post'):get()
    return response:json(0, 'ok', comments)
end

function _M:update()
    local args = request:all()
    local ok, msg = validator:check(args, {
        'avatar',
        'name',
        })
    if not ok then
        return response:json(0x000001, msg)
    end
    local user = auth:user()
    User:where('id', '=', user.id):update({
        avatar=args.avatar,
        name=args.name,
        city=args.city,
        email=args.email
    })
    return response:json(0, 'ok')
end

return _M

#!/bin/bash
# env_file="env.lua"
# if !(test -e "$env_file")
# then
#     echo "file not found"
# fi
# cat $env_file|grep "mysql_host"|while read line
# do
#     echo $line
# done
MYSQL_HOST="mysql-host"
MYSQL_USER="root"
MYSQL_PASSWORD="root"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD -e "\
CREATE DATABASE IF NOT EXISTS lua_china;
USE lua_china;
CREATE TABLE IF NOT EXISTS \`users\` (\
  \`id\` int(10) unsigned NOT NULL AUTO_INCREMENT,\
  \`nickname\` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',\
  \`phone\` varchar(255) COLLATE utf8_unicode_ci NOT NULL,\
  \`email\` varchar(255) COLLATE utf8_unicode_ci NOT NULL,\
  \`password\` varchar(255) COLLATE utf8_unicode_ci NOT NULL,\
  \`avatar\` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',\
  \`created_at\` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,\
  \`updated_at\` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\
  PRIMARY KEY (\`id\`)\
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
CREATE TABLE IF NOT EXISTS \`user_logs\` (
  \`id\` int(11) NOT NULL AUTO_INCREMENT,
  \`ip\` varchar(255) NOT NULL DEFAULT '',
  \`city\` varchar(10) NOT NULL DEFAULT '',
  \`country\` varchar(10) NOT NULL DEFAULT '',
  \`type\` varchar(255) NOT NULL DEFAULT '',
  \`time_at\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (\`id\`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `post_id` int(10) unsigned NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_post_id_foreign` (`post_id`),
  KEY `comments_user_id_foreign` (`user_id`),
  CONSTRAINT `comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `favors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `post_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `favors_post_id_foreign` (`post_id`),
  KEY `favors_user_id_foreign` (`user_id`),
  CONSTRAINT `favors_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favors_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_tag_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_count` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `excellent` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `posts_post_tag_id_foreign` (`post_tag_id`),
  KEY `posts_user_id_foreign` (`user_id`),
  CONSTRAINT `posts_post_tag_id_foreign` FOREIGN KEY (`post_tag_id`) REFERENCES `post_tags` (`id`) ON DELETE CASCADE,
  CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `post_tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

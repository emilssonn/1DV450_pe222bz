require "redis"

Api::V1::ApiBaseController.middleware.use "RateLimit"

redis_conf  = YAML.load(File.join(Rails.root, "config", "redis.yml"))
REDIS = Redis.new(:host => redis_conf["host"], :port => redis_conf["port"])

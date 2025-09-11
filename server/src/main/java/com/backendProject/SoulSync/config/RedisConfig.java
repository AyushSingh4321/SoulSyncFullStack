package com.backendProject.SoulSync.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisPassword;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceClientConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;

@Configuration
public class RedisConfig {

    private static final String REDIS_HOST = "prime-midge-10750.upstash.io";
    private static final int REDIS_PORT = 6379;
    private static final String REDIS_PASSWORD = "ASn-AAIncDFlYTMyYTQyMTlmZGU0NTU5ODc2NTlhYzk4MWQ1Y2U0MXAxMTA3NTA";

    @Bean
    public LettuceConnectionFactory redisConnectionFactory() {
        RedisStandaloneConfiguration config = new RedisStandaloneConfiguration();
        config.setHostName(REDIS_HOST);
        config.setPort(REDIS_PORT);
        config.setPassword(RedisPassword.of(REDIS_PASSWORD));

        LettuceClientConfiguration clientConfig = LettuceClientConfiguration.builder()
                .useSsl() // enable SSL
                .build();

        return new LettuceConnectionFactory(config, clientConfig);
    }

    @Bean
    public StringRedisTemplate redisTemplate(LettuceConnectionFactory connectionFactory) {
        return new StringRedisTemplate(connectionFactory);
    }
}

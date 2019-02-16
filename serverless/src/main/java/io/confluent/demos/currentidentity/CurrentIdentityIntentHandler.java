package io.confluent.demos.currentidentity;

import com.amazon.ask.dispatcher.request.handler.HandlerInput;
import com.amazon.ask.dispatcher.request.handler.RequestHandler;
import com.amazon.ask.model.Intent;
import com.amazon.ask.model.IntentRequest;
import com.amazon.ask.model.Request;
import com.amazon.ask.model.Response;
import com.amazon.ask.model.Slot;
import com.amazon.ask.request.Predicates;

import redis.clients.jedis.Jedis;

import java.util.Map;
import java.util.Optional;

public class CurrentIdentityIntentHandler implements RequestHandler {

    private static final String HERO_NAME_SLOT = "heroName";
    private static final String REDIS_HOST_ENV = "REDIS_HOST";
    private static final String REDIS_PORT_ENV = "REDIS_PORT";

    @Override
    public boolean canHandle(HandlerInput input) {

       return input.matches(Predicates.intentName("CurrentIdentityIntent"));
       
    }

    @Override
    public Optional<Response> handle(HandlerInput input) {

        Request request = input.getRequestEnvelope().getRequest();
        IntentRequest intentRequest = (IntentRequest) request;
        Intent intent = intentRequest.getIntent();
        Map<String, Slot> slots = intent.getSlots();

        Slot heroNameSlot = slots.get(HERO_NAME_SLOT);
        String heroName = heroNameSlot.getValue();
        heroName = heroName.toUpperCase();

        final String redisHost = System.getenv(REDIS_HOST_ENV);
        final String redisPort = System.getenv(REDIS_PORT_ENV);

        String currentIdentity = null;

        try (Jedis jedis = new Jedis(redisHost, Integer.parseInt(redisPort))) {

            if (jedis.exists(heroName)) {

                currentIdentity = jedis.get(heroName);

            }

        } catch (Exception ex) {

            currentIdentity = "Error: " + ex.getMessage();

        }

        String speechText = null;

        if (currentIdentity != null) {

            speechText = heroName + "'s current identity is " +
                currentIdentity.trim();

        } else {

            speechText = "I could not find " + heroName +
                "'s current identity. " +
                "<amazon:effect name=\"whispered\">Sorry...</amazon:effect>";

        }

        return input.getResponseBuilder()
                .withSpeech(speechText)
                .withSimpleCard("CurrentIdentity", speechText)
                .build();

    }

}
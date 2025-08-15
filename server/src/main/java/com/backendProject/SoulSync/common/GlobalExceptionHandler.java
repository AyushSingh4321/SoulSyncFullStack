package com.backendProject.SoulSync.common;

import com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationErrors(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();

        ex.getBindingResult().getFieldErrors().forEach(error -> {
            String field = error.getField();
            String message = error.getDefaultMessage();
            System.out.println("Validation error on field '" + field + "': " + message);
            errors.put(field, message);
        });

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errors);
    }
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleAllExceptions(Exception ex) {
        return ResponseEntity.status(500).body("Server error: " + ex.getMessage());
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<String> handleNotFound(NoHandlerFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("404 - Endpoint not found");
    }

    //added for handling extra fields
    @ExceptionHandler(UnrecognizedPropertyException.class)
    public ResponseEntity<Map<String, String>> handleUnknownFields(UnrecognizedPropertyException ex) {
        String unknownField = ex.getPropertyName(); // e.g., "username"
        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put("error", "Unknown field '" + unknownField + "' is not allowed");

        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, String>> handleJsonParseErrors(HttpMessageNotReadableException ex) {
        Throwable cause = ex.getCause();

        // Specifically handle unknown fields
        if (cause instanceof UnrecognizedPropertyException) {
            UnrecognizedPropertyException upe = (UnrecognizedPropertyException) cause;
            String unknownField = upe.getPropertyName(); // e.g., "username"

            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "Unknown field '" + unknownField + "' is not allowed");

            return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
        }

        // Fallback for other JSON parse errors
        Map<String, String> fallback = new HashMap<>();
        fallback.put("error", "Malformed JSON request");

        return new ResponseEntity<>(fallback, HttpStatus.BAD_REQUEST);
    }
}
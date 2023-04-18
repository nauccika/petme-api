package com.petme.api.controller;

import com.petme.api.UsersApi;
import com.petme.api.dto.UserDto;
import com.petme.api.mapper.UserMapper;
import com.petme.api.model.User;
import com.petme.api.repository.UserRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

@RequiredArgsConstructor
@RestController
public class UsersRestController implements UsersApi {

  private final UserRepository userRepository;

  private final UserMapper userMapper;

  @Override
  public ResponseEntity<Void> createUsers(UserDto userDto) {
    User user = userMapper.toEntity(userDto);
    userRepository.save(user);
    HttpHeaders headers = new HttpHeaders();
    headers.setLocation(UriComponentsBuilder.newInstance()
        .path("/users/{userId}").buildAndExpand(user.getId()).toUri());
    return new ResponseEntity<>(headers, HttpStatus.CREATED);
  }

  @Override
  public ResponseEntity<List<UserDto>> listUsers() {
    List<UserDto> userDtos = userMapper.toDto(userRepository.findAll());
    return new ResponseEntity<>(userDtos, HttpStatus.OK);
  }

  @Override
  public ResponseEntity<Void> deleteUsers(Long userId) {
    userRepository.deleteById(userId);
    return new ResponseEntity<>(HttpStatus.NO_CONTENT);
  }

  @Override
  public ResponseEntity<UserDto> getUserById(Long userId) {
    UserDto userDto = userMapper.toDto(userRepository.getReferenceById(userId));
    return new ResponseEntity<>(userDto, HttpStatus.OK);
  }
}

package com.petme.api.mapper;

import com.petme.api.dto.UserDto;
import com.petme.api.model.User;
import java.util.List;
import org.mapstruct.Mapper;

@Mapper
public interface UserMapper {

  UserDto toDto(User user);

  User toEntity(UserDto userDto);

  List<UserDto> toDto(List<User> users);

  List<User> toEntity(List<UserDto> userDtos);

}
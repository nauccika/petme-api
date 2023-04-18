package com.petme.api.model;

import java.time.Instant;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString(onlyExplicitlyIncluded = true)
@Entity
@Table(name = "tb_user")
public class User {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id", nullable = false)
  private Long id;

  @Size(max = 256)
  @NotNull
  @Column(name = "login_id", nullable = false, length = 256)
  private String loginId;

  @Size(max = 256)
  @Column(name = "user_name", length = 256)
  private String userName;

  @Size(max = 64)
  @Column(name = "password", length = 64)
  private String password;

  @Size(max = 512)
  @Column(name = "email", length = 512)
  private String email;

  @Size(max = 20)
  @Column(name = "phone", length = 20)
  private String phone;

  @Size(max = 18)
  @Column(name = "resident_registration_number", length = 18)
  private String residentRegistrationNumber;

  @Size(max = 1024)
  @Column(name = "street_name_address", length = 1024)
  private String streetNameAddress;

  @Size(max = 1024)
  @Column(name = "lot_number_address", length = 1024)
  private String lotNumberAddress;

  @Size(max = 16)
  @Column(name = "gender", length = 16)
  private String gender;

  @Size(max = 1)
  @Column(name = "receive_information_yn", length = 1)
  private String receiveInformationYn;

  @Size(max = 1)
  @Column(name = "receive_event_yn", length = 1)
  private String receiveEventYn;

  @Size(max = 4)
  @Column(name = "access_token", length = 4)
  private String accessToken;

  @Size(max = 1)
  @Column(name = "oauth_type", length = 1)
  private String oauthType;

  @Size(max = 32)
  @Column(name = "pet_type", length = 32)
  private String petType;

  @NotNull
  @Column(name = "current_point", nullable = false)
  private Integer currentPoint;

  @Column(name = "last_login")
  private Instant lastLogin;

  @NotNull
  @Column(name = "login_times", nullable = false)
  private Integer loginTimes;

  @Column(name = "withdrawal_date")
  private Instant withdrawalDate;

  @Size(max = 512)
  @Column(name = "withdrawal_cause", length = 512)
  private String withdrawalCause;

  @Size(max = 1)
  @Column(name = "use_yn", length = 1)
  private String useYn;

  @NotNull
  @Column(name = "modify_time", nullable = false)
  private Instant modifyTime;

  @NotNull
  @Column(name = "register_time", nullable = false)
  private Instant registerTime;

}
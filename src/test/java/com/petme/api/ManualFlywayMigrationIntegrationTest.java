package com.petme.api;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@SpringBootTest
public class ManualFlywayMigrationIntegrationTest {

  @Autowired
  private Flyway flyway;

  @Test
  public void skipAutomaticAndTriggerManualFlywayMigration() {
    flyway.migrate();
  }
}


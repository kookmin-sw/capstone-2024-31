package km.cd.backend.challenge.dto.enums;

import lombok.Getter;

@Getter
public enum FilePathEnum {
  CHALLENGES("challenges");

  private final String path;

  FilePathEnum(String path) {
    this.path = path;
  }
}
package model;

public class ConsultationType {
    private Integer typeId;
    private String typeName;
    private String description;
    private Boolean active;

    public ConsultationType() {}

    public Integer getTypeId() { return typeId; }
    public void setTypeId(Integer typeId) { this.typeId = typeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
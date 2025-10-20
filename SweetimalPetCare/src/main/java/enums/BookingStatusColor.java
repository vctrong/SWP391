package enums;

/**
 * Mapping between booking status codes and UI color classes / labels.
 * Use getBgClass() / getTextClass() in JSPs to render consistent colors.
 */
public enum BookingStatusColor {
	PENDING("PENDING", "Chờ xác nhận", "bg-yellow-200", "text-yellow-800"),
	CONFIRMED("CONFIRMED", "Đã xác nhận", "bg-green-200", "text-green-800"),
	IN_PROGRESS("IN_PROGRESS", "Đang thực hiện", "bg-blue-200", "text-blue-800"),
	COMPLETED("COMPLETED", "Hoàn tất", "bg-gray-200", "text-gray-800"),
	CANCELLED("CANCELLED", "Đã hủy", "bg-red-200", "text-red-800"),
	NO_SHOW("NO_SHOW", "Không đến", "bg-orange-200", "text-orange-800"),
	UNKNOWN("UNKNOWN", "Unknown", "bg-gray-100", "text-gray-700");

	private final String code;
	private final String label;
	private final String bgClass;
	private final String textClass;

	BookingStatusColor(String code, String label, String bgClass, String textClass) {
		this.code = code;
		this.label = label;
		this.bgClass = bgClass;
		this.textClass = textClass;
	}

	public String getCode() { return code; }
	public String getLabel() { return label; }
	public String getBgClass() { return bgClass; }
	public String getTextClass() { return textClass; }

	public static BookingStatusColor fromString(String s) {
		if (s == null) return UNKNOWN;
		try {
			return BookingStatusColor.valueOf(s.toUpperCase());
		} catch (IllegalArgumentException ex) {
			// Try matching common variants
			String norm = s.trim().toUpperCase();
			switch (norm) {
				case "PENDING": return PENDING;
				case "CONFIRMED": return CONFIRMED;
				case "IN_PROGRESS": case "INPROGRESS": return IN_PROGRESS;
				case "COMPLETED": case "COMPLETE": return COMPLETED;
				case "CANCELLED": case "CANCELED": return CANCELLED;
				case "NO_SHOW": return NO_SHOW;
				default: return UNKNOWN;
			}
		}
	}
}

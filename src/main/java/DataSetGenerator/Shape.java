package DataSetGenerator;


public abstract class Shape
{
	public abstract Point generateCorePoint();
	public abstract Point generateOverlappingPoint();
	public abstract boolean isCovered(Point point);
	public abstract boolean isInOutlierForbiddenZone(Point point);
}
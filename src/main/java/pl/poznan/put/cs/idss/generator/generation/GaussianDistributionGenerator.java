package pl.poznan.put.cs.idss.generator.generation;

import java.util.Random;
import org.apache.commons.lang3.Validate;


public class GaussianDistributionGenerator extends RandomGenerator
{
	private double standardDeviationCoefficient;

	public GaussianDistributionGenerator(Random generationAlgorithm,
										 int dimensionality,
										 double numStandardDeviations)
	{
            super(generationAlgorithm, dimensionality);
            Validate.validState(numStandardDeviations > 0);
            standardDeviationCoefficient = numStandardDeviations;
	}

	protected double getNumber(double mean, double range)
	{
		double value = generationAlgorithm.nextGaussian();
		return value * range/standardDeviationCoefficient + mean;
	}	
}
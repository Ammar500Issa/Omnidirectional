function mu = Adhesion(lambda, mu_peak)
    if lambda >= -1 && lambda <= -0.15
        mu = -(lambda + 0.15)*0.4*mu_peak - mu_peak;
    elseif lambda > -0.15 && lambda < 0.15
        mu = (lambda - 0.15)*mu_peak/0.15 + mu_peak;
    else
        mu = -(lambda - 0.15)*0.4*mu_peak + mu_peak;
    end
end
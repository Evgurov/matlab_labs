#include <complex>
#include "mex.hpp"
#include "mexAdapter.hpp"

class MexFunction : public matlab::mex::Function {
public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs); 

    void checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs, matlab::data::ArrayFactory& factory);
};

void MexFunction::operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
    matlab::data::ArrayFactory factory;
    checkArguments(outputs, inputs, factory);
    matlab::data::TypedArray<std::complex<double>> A = inputs[0];
    matlab::data::TypedArray<std::complex<double>> B = inputs[1];
    matlab::data::TypedArray<std::complex<double>> C = inputs[2];
    std::vector<std::size_t> dims = inputs[0].getDimensions();
    matlab::data::TypedArray<std::complex<double>> X1 = factory.createArray<std::complex<double>>({dims[0],dims[1]});
    matlab::data::TypedArray<std::complex<double>> X2 = factory.createArray<std::complex<double>>({dims[0],dims[1]});
    matlab::data::TypedArray<std::complex<double>> X3 = factory.createArray<std::complex<double>>({dims[0],dims[1]});
    matlab::data::TypedArray<std::complex<double>> X4 = factory.createArray<std::complex<double>>({dims[0],dims[1]});
    std::complex<double> x1;
    std::complex<double> x2;
    std::complex<double> x3;
    std::complex<double> x4;
    std::complex<double> a;
    std::complex<double> b;
    std::complex<double> c;
    std::complex<double> D;
    for (int i = 0; i < dims[0]; i++) {
        for (int j = 0; j < dims[1]; j++) {
            a = A[i][j];
            b = B[i][j];
            c = C[i][j];
            D = pow(b, 2) - (4. * a * c);
            x1 = sqrt((-b - sqrt(D))/(2. * a));
            x2 = -x1;
            x3 = sqrt((-b + sqrt(D))/(2. * a));
            x4 = -x3;
            X1[i][j] = x1;
            X2[i][j] = x2;
            X3[i][j] = x3;
            X4[i][j] = x4;
        }
    }
    if (outputs.size() == 2) {
        outputs[0] = X1;
        outputs[1] = X2;
    } else if (outputs.size() == 3) {
        outputs[0] = X1;
        outputs[1] = X2;
        outputs[2] = X3;
    } else if (outputs.size() == 4) {
        outputs[0] = X1;
        outputs[1] = X2;
        outputs[2] = X3;
        outputs[3] = X4;
    }
}

void MexFunction::checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs, matlab::data::ArrayFactory& factory) {
    std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
    
    if (inputs.size() != 3) {
        matlabPtr -> feval("error", 0, std::vector<matlab::data::Array>({factory.createScalar("Wrong number of input parameters")}));
    } else if (inputs[0].getType() != matlab::data::ArrayType::COMPLEX_DOUBLE || inputs[1].getType() != matlab::data::ArrayType::COMPLEX_DOUBLE ||
        inputs[2].getType() != matlab::data::ArrayType::COMPLEX_DOUBLE) {
        matlabPtr -> feval("error", 0, std::vector<matlab::data::Array>({factory.createScalar("Input parameters must be a complex-double matrices")}));
    } else if (!(inputs[0].getDimensions() == inputs[1].getDimensions() &&  inputs[1].getDimensions() == inputs[2].getDimensions())) {
        matlabPtr -> feval("error", 0, std::vector<matlab::data::Array>({factory.createScalar("Input parameters must be same-size matrices")}));
    } else if (outputs.size() < 2 || outputs.size() > 4) {
        matlabPtr -> feval("error", 0, std::vector<matlab::data::Array>({factory.createScalar("Wrong number of output parameters")}));
    }
}
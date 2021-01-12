#include <cmath>
#include "mex.hpp"
#include "mexAdapter.hpp"

class MexFunction : public matlab::mex::Function {
public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs); 

    void checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs, matlab::data::ArrayFactory& factory, std::vector<std::size_t>& dims);
    
    std::vector<double> getColumn(matlab::data::TypedArray<double>& InputMatrix, std::vector<std::size_t>& dims, int number);
    
    void putColumn(matlab::data::TypedArray<double>& InputMatrix, std::vector<std::size_t>& dims, std::vector<double> column, int number);
    
    std::vector<double> projection(std::vector<double> a, std::vector<double> b);
    
    double scalarProd(std::vector<double> a, std::vector<double> b);
    
    std::vector<double>& normalize(std::vector<double>& vect);
    
    void transp(matlab::data::TypedArray<double>& Matrix, std::vector<std::size_t>& dims);
    
    void matrixProd(matlab::data::TypedArray<double>& Prod, matlab::data::TypedArray<double>& A, matlab::data::TypedArray<double>& B, std::vector<std::size_t>& dims);
};

void MexFunction::operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
    matlab::data::ArrayFactory factory;
    std::vector<std::size_t> dims = inputs[0].getDimensions();
    checkArguments(outputs, inputs, factory, dims);
    matlab::data::TypedArray<double> InputMatrix = inputs[0];
    matlab::data::TypedArray<double> Q = factory.createArray<double>({dims[0],dims[1]});
    matlab::data::TypedArray<double> R = factory.createArray<double>({dims[0],dims[1]});
    std::vector<double> vect(dims[0]);
    std::vector<double> proj(dims[0]);
    for (int i = 0; i < dims[1]; i++) {
        vect = getColumn(InputMatrix, dims, i);
        for (int j = 0; j < i; j++) {
            proj = projection(vect, getColumn(Q, dims, j));
            for (int k = 0; k < dims[0]; k++)
                vect[k] = vect[k] - proj[k];
        }
        vect = normalize(vect);
        putColumn(Q, dims, vect, i);
    }
        outputs[0] = Q;
        transp(Q, dims);
        matrixProd(R, Q, InputMatrix, dims);
        outputs[1] = R;
}

std::vector<double> MexFunction::getColumn(matlab::data::TypedArray<double>& InputMatrix, std::vector<std::size_t>& dims, int number) {
    std::vector<double> column(dims[1]);
    for (int i = 0; i < dims[0]; i++)
        column[i] = InputMatrix[i][number];
    return column;
}

void MexFunction::putColumn(matlab::data::TypedArray<double>& InputMatrix, std::vector<std::size_t>& dims, std::vector<double> column, int number) {
    for (int i = 0; i < dims[0]; i++)
        InputMatrix[i][number] = column[i];
}

std::vector<double> MexFunction::projection(std::vector<double> a, std::vector<double> b) {
    std::vector<double> proj(a.size());
    double coef = scalarProd(a,b)/scalarProd(b,b);
    for (int i = 0; i < a.size(); i++) {
        proj[i] = b[i] * coef;
    }
    return proj;
}

double MexFunction::scalarProd(std::vector<double> a, std::vector<double> b) {
    double prod = 0;
    for (int i = 0; i < a.size(); i++) {
        prod += a[i] * b[i];
    }
    return prod;
}

std::vector<double>& MexFunction::normalize(std::vector<double>& vect) {
    double norm = 0;
    for (int i = 0; i < vect.size(); i++) {
        norm += vect[i] * vect[i];
    }
    norm = sqrt(norm);
    for (int i = 0; i < vect.size(); i++) {
        vect[i] = vect[i] / norm;
    }
    return vect;
}

void MexFunction::transp(matlab::data::TypedArray<double>& Matrix, std::vector<std::size_t>& dims) {
    double aux;
    for (int i = 0; i < dims[0]; i++) {
        for (int j = i; j < dims[1]; j++) {
            aux = Matrix[i][j];
            Matrix[i][j] = Matrix[j][i];
            Matrix[j][i] = aux;
        }
    }
}

void MexFunction::matrixProd(matlab::data::TypedArray<double>& Prod, matlab::data::TypedArray<double>& A, matlab::data::TypedArray<double>& B, std::vector<std::size_t>& dims) {
    double sum = 0;
    for (int i = 0; i < dims[0]; i++) {
        for (int j = 0; j < dims[1]; j++) {
            for (int k = 0; k < dims[0]; k++) {
                sum += A[i][k] * B[k][j];
            }
            Prod[i][j] = sum;
            sum = 0;
        }
    }
}
            
void MexFunction::checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs, matlab::data::ArrayFactory& factory, std::vector<std::size_t>& dims) {
    std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
    
    if (inputs.size() != 1) {
        matlabPtr -> feval("error", 0, std::vector<matlab::data::Array>({factory.createScalar("Wrong number of input parameters")}));
    } else if (dims[0] != dims[1]) {
        matlabPtr -> feval("error", 0, std::vector<matlab::data::Array>({factory.createScalar("Input parameter must be a square matrix")}));
    } else if (outputs.size() != 2) {
        matlabPtr -> feval("error", 0, std::vector<matlab::data::Array>({factory.createScalar("Wrong number of output parameters")}));
    }
}
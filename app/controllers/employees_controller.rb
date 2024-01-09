class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employees_path, notice: 'Employee created successfully.'
    else
      render :new
    end
  end

  def tax_deduction
    employees = Employee.all
    result = calculate_tax_deduction(employees)
    render json: result
  end

  private

  def calculate_tax_deduction(employees)
    result = []

    employees.each do |employee|
      total_salary = calculate_total_salary(employee)
      tax = calculate_tax(total_salary)
      cess = calculate_cess(total_salary, tax)

      result << {
        employee_code: employee.employee_code,
        first_name: employee.first_name,
        last_name: employee.last_name,
        yearly_salary: total_salary,
        tax_amount: tax,
        cess_amount: cess
      }
    end

    result
  end

  def calculate_total_salary(employee)
    doj = employee.doj.to_date
    current_date = Date.today

    # Calculate the number of months from the DOJ to the current date
    months_worked = (current_date.year * 12 + current_date.month) - (doj.year * 12 + doj.month)

    # Calculate total salary based on monthly salary
    total_salary = employee.salary * months_worked / 12.0

    total_salary
  end

  def calculate_tax(total_salary)
    case total_salary
    when 0..250000
        0
    when 250001..500000
        (total_salary - 250000) * 0.05
    when 500001..1000000
        250000 * 0.05 + (total_salary - 500000) * 0.1
    else
        250000 * 0.05 + 500000 * 0.1 + (total_salary - 1000000) * 0.2
    end
  end

  def calculate_cess(total_salary, tax)
    cess_percentage = total_salary > 2500000 ? 0.02 : 0
    cess_amount = (tax * cess_percentage).round(2)

    cess_amount
  end

  def employee_params
    params.require(:employee).permit(:employee_id, :first_name, :last_name, :email, :phone_numbers, :doj, :salary)
  end
end

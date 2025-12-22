output "lambda_arn" {
    value = aws_lambda_function.visit.invoke_arn
}

output "lambda_name" {
    value = aws_lambda_function.visit.id
}
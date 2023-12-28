FROM public.ecr.aws/docker/library/python:3.8-alpine

# copy package info early to install npms and delete npm command
WORKDIR /app
RUN pip3 install --user boto3
COPY sqs-consumer.py ./
EXPOSE 3000
#ENTRYPOINT ["bash","/usr/src/app/startup.sh"]
CMD ["/app/sqs-consumer.py"]
ENTRYPOINT ["python3"]
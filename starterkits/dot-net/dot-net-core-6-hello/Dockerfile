FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app
    
# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o out
WORKDIR /app/out
EXPOSE 5001
ENTRYPOINT ["dotnet", "HelloApi.dll","--urls=http://0.0.0.0:5001/"]
from django.db import models
# Create your models here.


# This is intro table of madarsa
class IntroMadrasa(models.Model):
    name = models.CharField(max_length=200)
    content = models.TextField(max_length=1000)
    full_image = models.ImageField(upload_to='app/Post/')
    logo = models.ImageField(upload_to='app/Post/')
    color_one = models.CharField(max_length=200)
    color_two = models.CharField(max_length=200)
    created_date = models.DateField(auto_now_add=True,null=True)
    updated_date = models.DateField(auto_now=True)
    Created_by = models.CharField(max_length=200,blank=True)
    updated_by = models.CharField(max_length=200,blank=True)


    def __str__(self):
        return self.name

# This is course table 
class Course(models.Model):
    name = models.CharField(max_length=200)
    content = models.TextField(max_length=1000)
    logo = models.ImageField(upload_to='app/Post/')
    created_date = models.DateField(auto_now_add=True,null=True)
    updated_date = models.DateField(auto_now=True)
    Created_by = models.CharField(max_length=200,blank=True)
    updated_by = models.CharField(max_length=200,blank=True)
    
    def __str__(self):
        return self.name
   
# This is Mission table 
class Targets(models.Model):
    name = models.CharField(max_length=200)
    content = models.TextField(max_length=1000)
    image = models.ImageField(upload_to='app/Post/')
    created_date = models.DateField(auto_now_add=True,null=True)
    updated_date = models.DateField(auto_now=True)
    Created_by = models.CharField(max_length=200,blank=True)
    updated_by = models.CharField(max_length=200,blank=True)
    
    def __str__(self):
        return self.name

        
# This is say tabel   
class Openions(models.Model):
    name = models.CharField(max_length=200)
    email = models.EmailField()
    profile_pic = models.ImageField(upload_to='app/Post/')
    title = models.CharField(max_length=200)
    message = models.TextField(max_length=1000)
    created_date = models.DateField(auto_now_add=True,null=True)
    updated_date = models.DateField(auto_now=True)
    Created_by = models.CharField(max_length=200,blank=True)
    updated_by = models.CharField(max_length=200,blank=True)
    
    def __str__(self):
        return self.name
   

# This is Profile Of Mudarriseen tabel   
class Teachers(models.Model):
    name = models.CharField(max_length=200)
    email = models.EmailField()
    profile_pic = models.ImageField(upload_to='app/Post/')
    phone_no = models.IntegerField()
    position = models.CharField(max_length=200)
    address = models.CharField(max_length=200)
    created_date = models.DateField(auto_now_add=True,null=True)
    updated_date = models.DateField(auto_now=True)
    Created_by = models.CharField(max_length=200,blank=True)
    updated_by = models.CharField(max_length=200,blank=True)
    
    def __str__(self):
        return self.name
class SocialAccounts(models.Model):
    teacher = models.ForeignKey(Teachers,on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    link = models.CharField(max_length=800)
    
    def __str__(self):
        return self.name
# This is Gallery tabel      
class Gallery(models.Model):
    image = models.ImageField(upload_to='app/Post/')
    content = models.TextField(max_length=1000)
    created_date = models.DateField(auto_now_add=True,null=True)
    updated_date = models.DateField(auto_now=True)
    Created_by = models.CharField(max_length=200,blank=True)
    updated_by = models.CharField(max_length=200,blank=True)
    
    def __str__(self):
        return self.content
   